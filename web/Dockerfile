FROM docker.io/library/nginx:latest

# Copiar HTML
COPY index.html /usr/share/nginx/html/index.html

# Copiar certificado y clave
COPY certs/server.crt /etc/nginx/certs/server.crt
COPY certs/server.key /etc/nginx/certs/server.key

# Copiar autenticación básica
COPY auth/.htpasswd /etc/nginx/auth/.htpasswd

# Copiar configuración HTTPS
COPY nginx.conf /etc/nginx/conf.d/default.conf
