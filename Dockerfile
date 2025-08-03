# Use the official Flutter image
FROM debian:latest

# Install dependencies
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
ENV FLUTTER_HOME="/flutter"
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Download and install Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME
RUN flutter doctor
RUN flutter config --enable-web

# Set up the app
WORKDIR /app

# Copy pubspec files first for better caching
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the app
COPY . .

# Build the app
RUN flutter build web --release

# Make startup script executable
RUN chmod +x start.sh

# Expose port
EXPOSE 8080

# Start the app using the script
CMD ["./start.sh"] 