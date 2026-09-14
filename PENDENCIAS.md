# Pendências antes de publicar

Este pacote está tecnicamente completo e passa em `scripts/validate.sh`, mas foi montado com suposições que precisam de confirmação antes do primeiro deploy público.

## Bloqueantes (o site não deve ir ao ar sem isso)

1. **Domínio de produção.** Usei `espacothaisamontenegro.com.br` como placeholder em todo o código: meta tags, `canonical`, Open Graph, JSON-LD, `sitemap.xml`, `robots.txt`, CSP e `docker-stack.yml`. Se o domínio real for outro, é necessário substituir essa string em todos os arquivos antes do deploy (um `grep -rl "espacothaisamontenegro.com.br" .` lista todos os pontos).
2. **Servidor de destino.** `DEPLOY.md` assume a mesma infraestrutura Docker Swarm + Traefik confirmada em outro projeto da casa (rede `minha_rede`, entrypoint `websecure`, certresolver `letsencryptresolver`, IP `185.182.184.175`). Se este site for para outra VPS, todos esses valores mudam.

## Importantes (o site funciona, mas fica incompleto ou impreciso sem isso)

3. **Nome fantasia.** O campo "Título do Estabelecimento" no cartão CNPJ está oculto (`********`). Usei **"Espaço Thaisa Montenegro"**, inferido do e-mail cadastral (`espacothaisamontenegro@gmail.com`). Confirmar se é esse o nome que ela usa comercialmente.
4. **Copy de "Áreas de atuação".** Os três itens (estética facial, estética corporal, formação e mentoria) estão no nível de categoria, deduzidos dos CNAEs do CNPJ — não inventei nomes de procedimentos específicos porque não tenho essa informação. Substituir pelos serviços reais que ela vende (nomes, e se fizer sentido, uma frase de posicionamento por serviço).
5. **Fotos adicionais.** Só há uma foto no site (a enviada em 10/09/2026, usada no hero). Se ela tiver mais fotos do espaço físico ou de outros ângulos, dá para enriquecer a seção "Sobre" ou "Localização".

## Resolvido nesta rodada

- ~~Número de WhatsApp~~ — confirmado: (81) 98482-2268, já aplicado em todos os CTAs do site.
- ~~Foto do hero~~ — recebida e integrada (`assets/thaisa-hero.webp`), com recorte 3:4 e imagem Open Graph gerada a partir dela.
