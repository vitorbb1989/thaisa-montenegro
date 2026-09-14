# Deploy — Espaço Thaisa Montenegro

Domínio de produção (placeholder, confirmar — ver PENDENCIAS.md): `https://espacothaisamontenegro.com.br`

## Pré-requisitos no servidor

- Docker Swarm ativo (`docker info` deve mostrar `Swarm: active`).
- Traefik v3 já implantado e operacional, gerenciando `entrypoints`, `certresolver` e a rede compartilhada.
- Rede externa `minha_rede` já criada e utilizada pelo Traefik.

Estes valores foram assumidos como iguais aos de outros sites estáticos já rodando na infraestrutura da casa (confirmado anteriormente via `docker service inspect traefik_traefik --pretty` em outro projeto). **Confirme antes do primeiro deploy que este site vai para a mesma VPS:**

```bash
docker info
docker node ls
docker stack ls
docker service ls
docker network inspect minha_rede
docker service inspect <serviço-do-traefik> --pretty
```

| Item | Valor assumido |
|---|---|
| Rede Traefik | `minha_rede` |
| EntryPoint HTTPS | `websecure` (porta 443; `web`/porta 80 redireciona) |
| Certresolver | `letsencryptresolver` |
| Label de rede | `traefik.swarm.network` (provider `--providers.swarm=true`) |
| IP do servidor | `185.182.184.175` (mesmo de outros sites estáticos da casa — confirmar) |

Os labels em `docker-stack.yml` já refletem esses valores. Não altere a configuração global do Traefik para se adequar a este projeto.

## Diretório no servidor

```
/opt/thaisamontenegro/
├── repo/       # clone do repositório, branch main
├── backups/    # backups com timestamp, nunca sobrescritos/apagados
├── deploy/     # artefatos de deploy, se necessário
└── logs/       # logs de deploy
```

Se `/opt/thaisamontenegro` já existir com conteúdo desconhecido: liste o conteúdo, identifique o que é, faça backup com timestamp em `backups/` e não sobrescreva nada sem confirmar do que se trata.

## Passo a passo

```bash
cd /opt/thaisamontenegro/repo
git fetch origin
git checkout main
git pull --ff-only origin main

GIT_SHA="$(git rev-parse --short HEAD)"

bash scripts/validate.sh

docker build -t "thaisamontenegro-site:${GIT_SHA}" .

IMAGE_TAG="${GIT_SHA}" docker stack deploy \
  --resolve-image never \
  -c docker-stack.yml \
  thaisamontenegro
```

Não use `latest`. Não implante se a validação ou o build falharem.

Alternativa: executar `bash scripts/deploy.sh`, que encapsula os passos acima (confere branch `main`, árvore limpa, roda `validate.sh`, builda com a tag do commit, implanta e aguarda convergência).

## Validação pós-deploy

```bash
docker stack services thaisamontenegro
docker stack ps thaisamontenegro --no-trunc
docker service inspect thaisamontenegro_web --pretty
docker service logs --tail 100 thaisamontenegro_web
```

Confirme: serviço 1/1, sem loop de reinicialização, imagem e tag corretas, rede `minha_rede`, router `thaisamontenegro` com `Host(espacothaisamontenegro.com.br)`.

## Testes públicos

```bash
curl -I https://espacothaisamontenegro.com.br/
curl -I https://espacothaisamontenegro.com.br/politica-de-privacidade.html
curl -I https://espacothaisamontenegro.com.br/termos-de-uso.html
curl -I https://espacothaisamontenegro.com.br/robots.txt
curl -I https://espacothaisamontenegro.com.br/sitemap.xml
curl -I https://espacothaisamontenegro.com.br/assets/logo.svg
curl -I https://espacothaisamontenegro.com.br/assets/thaisa-hero.webp
curl -I https://espacothaisamontenegro.com.br/assets/og-image.png
curl -I https://espacothaisamontenegro.com.br/rota-inexistente-teste
```

A última chamada deve retornar `404`. Verifique também:

```bash
curl -s https://espacothaisamontenegro.com.br/ | grep -F "espacothaisamontenegro.com.br"
curl -s https://espacothaisamontenegro.com.br/ | grep -Ei "taisa|thaissa|thaiza"
```

A segunda busca não deve retornar nenhuma linha (grafias incorretas do nome).

## DNS

Antes do deploy público, valide:

```bash
dig +short espacothaisamontenegro.com.br A
```

O resultado deve ser o IP do servidor de destino (assumido `185.182.184.175` — confirmar). Se ainda não apontar:

1. Finalize o código, faça commit e push.
2. **Não** force emissão repetida de certificado.
3. **Não** reinicie o Traefik.
4. **Não** realize o deploy público.
5. Informe **DNS PENDENTE** e o registro necessário:

```
Tipo: A
Host: espacothaisamontenegro (ou @, conforme o domínio final)
Destino: <IP do servidor de destino>
```

## Rollback

```bash
bash scripts/rollback.sh <TAG_ANTERIOR>
```

A tag anterior deve ser informada explicitamente (short SHA do commit correspondente à imagem já testada). O script nunca escolhe uma imagem automaticamente.

## Proibições neste deploy

- Não alterar/reiniciar o Traefik ou o Portainer.
- Não executar `docker system prune` ou equivalentes.
- Não publicar portas diretamente (tráfego somente via Traefik).
- Não remover redes, volumes, imagens ou serviços de outras stacks.
- Não usar a tag `latest`.
- Não fazer force push no repositório.
