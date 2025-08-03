# Multi-stage build para reducir el tamaño final
FROM debian:latest AS build-env

# Instalar solo las dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Configurar Flutter
ENV FLUTTER_HOME="/opt/flutter"
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Descargar Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME
WORKDIR $FLUTTER_HOME
RUN git fetch && git checkout 3.13.0

# Habilitar web
RUN flutter config --enable-web

# Configurar la aplicación
WORKDIR /app
COPY pubspec.yaml .
COPY pubspec.lock .

# Obtener dependencias
RUN flutter pub get

# Copiar solo los archivos necesarios
COPY lib/ lib/
COPY web/ web/
COPY analysis_options.yaml .

# Construir la aplicación
RUN flutter build web --release --web-renderer html --no-tree-shake-icons

# Limpiar archivos innecesarios
RUN rm -rf .dart_tool \
    && rm -rf build/web/assets/packages \
    && find build/web -name '*.map' -delete \
    && rm -rf $FLUTTER_HOME/.pub-cache \
    && rm -rf $FLUTTER_HOME/bin/cache

# Imagen final más pequeña
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Configuración de nginx optimizada
RUN echo 'events { worker_connections 1024; }' > /etc/nginx/nginx.conf && \
    echo 'http {' >> /etc/nginx/nginx.conf && \
    echo '  include /etc/nginx/mime.types;' >> /etc/nginx/nginx.conf && \
    echo '  server {' >> /etc/nginx/nginx.conf && \
    echo '    listen $PORT;' >> /etc/nginx/nginx.conf && \
    echo '    location / {' >> /etc/nginx/nginx.conf && \
    echo '      root /usr/share/nginx/html;' >> /etc/nginx/nginx.conf && \
    echo '      try_files $uri $uri/ /index.html;' >> /etc/nginx/nginx.conf && \
    echo '    }' >> /etc/nginx/nginx.conf && \
    echo '  }' >> /etc/nginx/nginx.conf && \
    echo '}' >> /etc/nginx/nginx.conf

# Script de inicio
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'envsubst < /etc/nginx/nginx.conf > /tmp/nginx.conf' >> /start.sh && \
    echo 'nginx -c /tmp/nginx.conf -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

EXPOSE $PORT
CMD ["/start.sh"] 