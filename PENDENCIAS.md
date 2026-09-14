# Pendências antes de publicar

Este pacote está tecnicamente completo e passa em `scripts/validate.sh`. Os dois bloqueantes de infraestrutura já foram confirmados; restam apenas itens de conteúdo (não impedem o deploy).

## Importantes (o site funciona, mas fica incompleto ou impreciso sem isso)

3. **Nome fantasia.** O campo "Título do Estabelecimento" no cartão CNPJ está oculto (`********`). Usei **"Espaço Thaisa Montenegro"**, inferido do e-mail cadastral (`espacothaisamontenegro@gmail.com`). Confirmar se é esse o nome que ela usa comercialmente.
4. **Copy de "Áreas de atuação".** Os três itens (estética facial, estética corporal, formação e mentoria) estão no nível de categoria, deduzidos dos CNAEs do CNPJ — não inventei nomes de procedimentos específicos porque não tenho essa informação. Substituir pelos serviços reais que ela vende (nomes, e se fizer sentido, uma frase de posicionamento por serviço).
5. **Fotos adicionais.** Só há uma foto no site (a enviada em 10/09/2026, usada no hero). Se ela tiver mais fotos do espaço físico ou de outros ângulos, dá para enriquecer a seção "Sobre" ou "Localização".

## Resolvido nesta rodada

- ~~Número de WhatsApp~~ — confirmado: (81) 98482-2268, já aplicado em todos os CTAs do site.
- ~~Foto do hero~~ — recebida e integrada (`assets/thaisa-hero.webp`), com recorte 3:4 e imagem Open Graph gerada a partir dela.
- ~~Domínio de produção~~ — confirmado: `lp.thaisamontenegro.com.br`, aplicado em todo o código.
- ~~Servidor de destino~~ — confirmado: mesma VPS (Docker Swarm + Traefik, rede `minha_rede`, IP `185.182.184.175`), DNS já apontando corretamente.
- ~~Telefone institucional~~ — o cartão CNPJ traz um único telefone, (81) 8482-2268, que é o mesmo número do WhatsApp sem o 9º dígito de celular. O site tinha um segundo número, (81) 9419-7583, que não constava em nenhum documento e foi removido/substituído por (81) 98482-2268 em todos os pontos (JSON-LD, rodapé, política de privacidade, termos de uso).
