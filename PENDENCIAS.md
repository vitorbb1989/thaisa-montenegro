# Pendências antes de publicar

Este pacote está tecnicamente completo e passa em `scripts/validate.sh`. Os dois bloqueantes de infraestrutura já foram confirmados; restam apenas itens de conteúdo (não impedem o deploy).

## Bloqueante (verificar antes do próximo deploy)

6. **Divergência na razão social.** O cartão CNPJ (documento oficial, enviado em 14/09/2026) traz **"THAISA MARQUES MONTENEGRO MAIA"** como Nome Empresarial. Na mesma conversa, depois, foi informado **"Thaisa da Silva Montenegro"** como razão social. Essas duas informações são incompatíveis e eu não alterei o nome jurídico no site — `legalName` no JSON-LD, o texto das páginas de Política de Privacidade e Termos de Uso, e o bloco legal do rodapé continuam com **"Thaisa Marques Montenegro Maia"**, que é o que consta no documento oficial. Antes de mexer nisso, confirmar qual dos dois nomes está correto (ex.: nome de casada mudou após a emissão do cartão CNPJ? erro de digitação em um dos dois?) — dado o CNPJ e o nome empresarial serem a mesma coisa para fins legais, prefiro manter o que está no documento até a confirmação.

## Importantes (o site funciona, mas fica incompleto ou impreciso sem isso)

4. **Copy de "Áreas de atuação".** Os três itens (estética facial, estética corporal, formação e mentoria) estão no nível de categoria, deduzidos dos CNAEs do CNPJ — não inventei nomes de procedimentos específicos porque não tenho essa informação. Substituir pelos serviços reais que ela vende (nomes, e se fizer sentido, uma frase de posicionamento por serviço).

## Resolvido nesta rodada

- ~~Número de WhatsApp~~ — confirmado: (81) 98482-2268, já aplicado em todos os CTAs do site.
- ~~Foto do hero~~ — recebida e integrada (`assets/thaisa-hero.webp`), com recorte 3:4 e imagem Open Graph gerada a partir dela.
- ~~Domínio de produção~~ — confirmado: `lp.thaisamontenegro.com.br`, aplicado em todo o código.
- ~~Servidor de destino~~ — confirmado: mesma VPS (Docker Swarm + Traefik, rede `minha_rede`, IP `185.182.184.175`), DNS já apontando corretamente.
- ~~Telefone institucional~~ — o cartão CNPJ traz um único telefone, (81) 8482-2268, que é o mesmo número do WhatsApp sem o 9º dígito de celular. O site tinha um segundo número, (81) 9419-7583, que não constava em nenhum documento e foi removido/substituído por (81) 98482-2268 em todos os pontos (JSON-LD, rodapé, política de privacidade, termos de uso).
- ~~Nome fantasia~~ — confirmado: **"Thaisa Montenegro"**. Também bate com o letreiro físico na recepção do espaço (foto `assets/espaco-recepcao.webp`, enviada em 14/09/2026). Trocado em todo o site (título, meta tags, JSON-LD `name`, cabeçalho, rodapé, páginas legais) — mantendo apenas o `legalName` do JSON-LD com o nome do cartão CNPJ (ver item 6, acima).
- ~~Fotos adicionais~~ — recebidas duas fotos em 14/09/2026 (retrato da Thaisa e a recepção com o letreiro) e integradas na seção "Sobre" (`assets/thaisa-sobre.webp`, `assets/espaco-recepcao.webp`).
