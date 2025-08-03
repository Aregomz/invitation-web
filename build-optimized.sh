#!/bin/bash
set -e

echo "🚀 Building optimized Flutter web app..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
rm -rf build/

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build web app with optimizations
echo "🔨 Building web app with optimizations..."
flutter build web --release --web-renderer html --no-tree-shake-icons --dart-define=FLUTTER_WEB_USE_SKIA=false

# Build Docker image
echo "🐳 Building Docker image..."
docker build -t invitation-app:optimized .

# Show image size
echo "📊 Image size information:"
docker images invitation-app:optimized --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

echo "✅ Build completed successfully!"
echo ""
echo "To run locally:"
echo "docker run -p 8080:8080 invitation-app:optimized"
echo ""
echo "To push to Railway:"
echo "railway up" 