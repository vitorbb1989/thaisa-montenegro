# ESPAÇO THAISA MONTENEGRO

Site institucional estático de **Thaisa Marques Montenegro Maia** (CNPJ 24.783.727/0001-50), nome fantasia assumido como "Espaço Thaisa Montenegro" — estética facial e corporal no Riomar Trade Center, Pina, Recife/PE.

Este site foi construído no mesmo padrão de outro projeto da casa (site institucional para verificação de negócio no Meta Business): demonstrar consistência cadastral (razão social, CNPJ e endereço idênticos ao CNPJ) e presença digital, com política de privacidade e termos de uso publicados. **Este site não garante, por si só, aprovação em processos de verificação empresarial da Meta ou de qualquer outra plataforma** — a aprovação depende também da documentação enviada e do cadastro da empresa nessas plataformas.

## ⚠️ Pendências antes de publicar (ver PENDENCIAS.md)

Este pacote está completo e validado, mas foi montado com dados que precisam de confirmação: nome fantasia, domínio de produção e servidor de destino. Ver `PENDENCIAS.md` para a lista exata.

## Dados do projeto

- **Nome:** Espaço Thaisa Montenegro
- **Razão social:** Thaisa Marques Montenegro Maia — CNPJ 24.783.727/0001-50
- **Domínio de produção (placeholder, a confirmar):** `lp.thaisamontenegro.com.br`
- **Tecnologia:** HTML, CSS e JavaScript estáticos — sem framework, sem processo de build.

## Estrutura de arquivos

```
/
├── index.html
├── styles.css
├── script.js
├── politica-de-privacidade.html
├── termos-de-uso.html
├── robots.txt
├── sitemap.xml
├── favicon.svg
├── README.md
├── PENDENCIAS.md
├── vercel.json
├── Dockerfile
├── nginx.conf
├── security-headers.conf
├── docker-stack.yml
├── .dockerignore
├── .gitignore
├── DEPLOY.md
├── scripts/
│   ├── deploy.sh
│   ├── validate.sh
│   └── rollback.sh
└── assets/
    ├── logo.svg          (monograma "TM", vetor — usado também como favicon)
    ├── thaisa-hero.webp  (foto enviada em 10/09/2026, recortada 3:4 para o hero)
    └── og-image.png      (1200×630, gerado a partir da mesma foto, para preview em redes sociais)
```

## Decisões de design

- **Paleta:** pedra quente (`#EDE7DD`), tinta profunda (`#1E1912`), latão envelhecido (`#A9803D`) e terracota muted (`#7A3F2C`) — evita o clichê "cream + terracota vivo" e a estética de card SaaS genérica.
- **Tipografia:** Fraunces (display, serif editorial) + Work Sans (texto/UI), carregadas via Google Fonts. Sem elas, o navegador cai em serif/sans do sistema — o layout não quebra, só perde personalidade.
- **Layout:** editorial, alinhado à esquerda, seções separadas por hairlines — não por cards com sombra. "Áreas de atuação" é tratado como menu (lista com hairline), não como grade de cards.
- **Foto:** a foto enviada em 10/09/2026 é o elemento hero principal, com moldura fina e um selo do monograma sobreposto. O emblema vetorial (monograma "TM") ficou como marca (favicon, logo do header, selo sobre a foto) — não mais como substituto de foto no hero.
- **Copy de "Áreas de atuação":** está no nível de categoria (estética facial / estética corporal / formação e mentoria), deduzido dos CNAEs do CNPJ (96.02-5-02 e 85.99-6-04). **Precisa ser substituída pelos nomes reais dos procedimentos/serviços dela** antes de publicar — não inventei nomes de procedimentos específicos.

## Execução local

Os caminhos são todos relativos — basta abrir `index.html` com duplo clique, sem precisar de servidor.

Alternativa com servidor:
```bash
python -m http.server 8080
```
Acesse em `http://localhost:8080`.

## Validação e deploy

```bash
bash scripts/validate.sh
docker build -t "thaisamontenegro-site:$(git rev-parse --short HEAD)" .
IMAGE_TAG="$(git rev-parse --short HEAD)" docker stack deploy --resolve-image never -c docker-stack.yml thaisamontenegro
```

Ver **[DEPLOY.md](DEPLOY.md)** para o passo a passo completo, incluindo os valores de infraestrutura (rede Traefik, certresolver) assumidos como iguais aos de outros sites estáticos da casa — **confirmar antes do primeiro deploy**.

## E-mail institucional

`espacothaisamontenegro@gmail.com` é o e-mail cadastral do CNPJ e é usado no site como contato institucional e nas páginas legais. Por ser uma caixa @gmail (não do domínio próprio), não há registros MX/SPF/DKIM/DMARC a configurar para o domínio do site por causa dele.

## Checklist pós-deploy

- [ ] Confirmar que o HTTPS está ativo e válido.
- [ ] Testar a página inicial (`/`).
- [ ] Testar a Política de Privacidade (`/politica-de-privacidade.html`).
- [ ] Testar os Termos de Uso (`/termos-de-uso.html`).
- [ ] Testar `robots.txt` e `sitemap.xml`.
- [ ] Verificar a tag `canonical`, Open Graph e Twitter Card em cada página.
- [ ] Validar o JSON-LD (BeautySalon) em um validador de rich results.
- [ ] Conferir CNPJ, razão social, endereço, telefone e e-mail exibidos contra o cartão CNPJ.
- [ ] Confirmar que o botão "Agendar no WhatsApp" abre uma conversa real.
