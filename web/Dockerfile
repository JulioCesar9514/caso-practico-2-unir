FROM docker.io/library/nginx:latest

# Instalar openssl y apache2-utils para generar certificados y autenticacion basica
RUN apt-get update && apt-get install -y openssl apache2-utils

# Crear certificados autofirmados dentro del contenedor
RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -nodes -days 365 \
      -newkey rsa:2048 \
      -keyout /etc/nginx/certs/server.key \
      -out /etc/nginx/certs/server.crt \
      -subj "/CN=localhost"

# Crear autenticacion basica dentro del contenedor
RUN mkdir -p /etc/nginx/auth && \
    htpasswd -bc /etc/nginx/auth/.htpasswd uniradmin password123

# Copiar HTML
COPY index.html /usr/share/nginx/html/index.html

# Copiar configuración HTTPS
COPY nginx.conf /etc/nginx/conf.d/default.conf
