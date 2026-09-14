#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

fail=0
err() { echo "FALHA: $1" >&2; fail=1; }
ok() { echo "OK: $1"; }

# 1. Arquivos obrigatórios
required_files=(
  index.html
  styles.css
  script.js
  politica-de-privacidade.html
  termos-de-uso.html
  robots.txt
  sitemap.xml
  favicon.svg
  vercel.json
  Dockerfile
  nginx.conf
  security-headers.conf
  docker-stack.yml
  assets/logo.svg
  assets/thaisa-hero.webp
  assets/og-image.png
)
for f in "${required_files[@]}"; do
  if [ -f "$f" ]; then ok "arquivo presente: $f"; else err "arquivo ausente: $f"; fi
done

site_files=(
  index.html styles.css script.js politica-de-privacidade.html termos-de-uso.html
  robots.txt sitemap.xml favicon.svg vercel.json
)

# 2. Grafias incorretas de Thaisa/Montenegro (apenas nos arquivos publicados do site)
if grep -nHiE "\btaisa\b|\bthaissa\b|\bthaiza\b|\bmontenegro\b.{0,3}\bmaya\b|montenegrro" "${site_files[@]}"; then
  err "grafia incorreta de Thaisa/Montenegro encontrada"
else
  ok "nenhuma grafia incorreta de Thaisa/Montenegro"
fi

# 3. Número de WhatsApp placeholder esquecido
if grep -nH "5581900000000" "${site_files[@]}"; then
  err "número de WhatsApp placeholder ainda presente"
else
  ok "nenhum número de WhatsApp placeholder"
fi

# 4. Domínio de produção presente nos pontos obrigatórios
for f in index.html politica-de-privacidade.html termos-de-uso.html robots.txt sitemap.xml; do
  if grep -q "lp.thaisamontenegro.com.br" "$f"; then
    ok "domínio de produção presente em $f"
  else
    err "domínio de produção ausente em $f"
  fi
done

# 5. Placeholders / lorem ipsum — apenas nos arquivos publicados do site.
#    TODO/FIXME é checado sensível a maiúsculas (marcador de código), para não colidir
#    com a palavra portuguesa comum "todo/toda/todos" no conteúdo real do site.
if grep -nHiE "lorem ipsum|xxx-xxx-xxxx|placeholder" "${site_files[@]}"; then
  err "placeholder ou lorem ipsum encontrado"
else
  ok "nenhum placeholder encontrado"
fi
if grep -nHE "\bTODO\b|\bFIXME\b" "${site_files[@]}"; then
  err "marcador TODO/FIXME encontrado"
else
  ok "nenhum marcador TODO/FIXME encontrado"
fi

# 6. JavaScript inline incompatível com CSP (tag <script> sem src e sem type=application/ld+json)
inline_script_hits=$(grep -n '<script' index.html politica-de-privacidade.html termos-de-uso.html 2>/dev/null \
  | grep -v 'src=' \
  | grep -v 'application/ld+json' || true)
if [ -n "$inline_script_hits" ]; then
  echo "$inline_script_hits"
  err "script inline potencialmente incompatível com CSP"
else
  ok "nenhum script inline incompatível com CSP"
fi

# 6b. Atributos style="" inline (também bloqueados pela CSP sem 'unsafe-inline' em style-src)
inline_style_hits=$(grep -n 'style="' index.html politica-de-privacidade.html termos-de-uso.html 2>/dev/null || true)
if [ -n "$inline_style_hits" ]; then
  echo "$inline_style_hits"
  err "atributo style inline encontrado (incompatível com a CSP configurada)"
else
  ok "nenhum atributo style inline"
fi

# 7. JSON-LD válido
if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PYEOF' || fail=1
import re, json, sys
html = open("index.html", encoding="utf-8").read()
m = re.search(r'<script type="application/ld\+json">\n(.*?)\n</script>', html, re.S)
if not m:
    print("FALHA: bloco JSON-LD não encontrado")
    sys.exit(1)
try:
    json.loads(m.group(1))
    print("OK: JSON-LD válido")
except Exception as e:
    print(f"FALHA: JSON-LD inválido: {e}")
    sys.exit(1)
PYEOF
else
  echo "AVISO: python3 não encontrado, pulando validação estrutural do JSON-LD"
fi

# 7b. Hash do CSP corresponde ao conteúdo atual do JSON-LD
if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PYEOF' || fail=1
import re, hashlib, base64, sys
html = open("index.html", encoding="utf-8").read()
m = re.search(r'<script type="application/ld\+json">\n(.*?)\n</script>', html, re.S)
if not m:
    sys.exit(1)
digest = hashlib.sha256(m.group(1).encode("utf-8")).digest()
expected = "sha256-" + base64.b64encode(digest).decode()
conf = open("security-headers.conf", encoding="utf-8").read()
if expected in conf:
    print(f"OK: hash do JSON-LD confere com security-headers.conf ({expected})")
else:
    print(f"FALHA: hash do JSON-LD não bate com security-headers.conf — esperado {expected}")
    sys.exit(1)
PYEOF
fi

# 8. vercel.json válido
if command -v python3 >/dev/null 2>&1; then
  python3 -c "import json; json.load(open('vercel.json'))" && ok "vercel.json válido" || err "vercel.json inválido"
fi

# 9. sitemap.xml válido
if command -v python3 >/dev/null 2>&1; then
  python3 -c "import xml.etree.ElementTree as ET; ET.parse('sitemap.xml')" && ok "sitemap.xml válido" || err "sitemap.xml inválido"
fi

# 9b. SVGs são XML bem formado
if command -v python3 >/dev/null 2>&1; then
  for svg in favicon.svg assets/logo.svg; do
    python3 -c "import xml.etree.ElementTree as ET; ET.parse('$svg')" \
      && ok "$svg é XML válido" \
      || err "$svg não é XML válido (ex.: '&' sem ser '&amp;' quebra a imagem no navegador)"
  done
fi

# 10. robots.txt aponta para o sitemap correto
if grep -q "^Sitemap: https://lp.thaisamontenegro.com.br/sitemap.xml$" robots.txt; then
  ok "robots.txt aponta para o sitemap correto"
else
  err "robots.txt não aponta para o sitemap correto"
fi

# 11. Links locais quebrados (href/src relativos apontando para arquivos inexistentes)
broken_links_file="$(mktemp)"
trap 'rm -f "$broken_links_file"' EXIT
for f in index.html politica-de-privacidade.html termos-de-uso.html; do
  refs=$(grep -oE '(href|src)="[^"#][^"]*"' "$f" | sed -E 's/^(href|src)="//; s/"$//')
  while IFS= read -r ref; do
    [ -z "$ref" ] && continue
    case "$ref" in
      http*|mailto:*|tel:*) continue ;;
    esac
    target="${ref%%#*}"
    [ -z "$target" ] && continue
    if [ ! -f "$target" ]; then
      echo "link local quebrado em $f -> $target" >> "$broken_links_file"
    fi
  done <<< "$refs"
done
if [ -s "$broken_links_file" ]; then
  cat "$broken_links_file"
  err "links locais quebrados encontrados"
else
  ok "nenhum link local quebrado"
fi

if [ "$fail" -ne 0 ]; then
  echo "VALIDAÇÃO FALHOU"
  exit 1
fi

echo "VALIDAÇÃO OK"
