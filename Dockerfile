FROM nginx:1.27-alpine

RUN rm -f /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY security-headers.conf /etc/nginx/security-headers.conf

COPY index.html politica-de-privacidade.html termos-de-uso.html /usr/share/nginx/html/
COPY styles.css script.js robots.txt sitemap.xml favicon.svg /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/

RUN addgroup -g 101 -S nginx 2>/dev/null; \
    chown -R nginx:nginx /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:80/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
