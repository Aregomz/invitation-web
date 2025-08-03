# Use the official Flutter image
FROM debian:latest AS build-env

# Install necessary build dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Set up Flutter
ENV FLUTTER_HOME="/opt/flutter"
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Download Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME
WORKDIR $FLUTTER_HOME
RUN git fetch && git checkout 3.16.9

# Enable web support
RUN flutter config --enable-web

# Set up the app
WORKDIR /app
COPY . .

# Get dependencies
RUN flutter pub get

# Build the app
RUN flutter build web --release --web-renderer html

# Serve the app
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Create a simple nginx config
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

# Create startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'envsubst < /etc/nginx/nginx.conf > /tmp/nginx.conf' >> /start.sh && \
    echo 'nginx -c /tmp/nginx.conf -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

EXPOSE $PORT
CMD ["/start.sh"] 