#!/bin/bash
set -e

echo "🚀 Building optimized Flutter web app..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

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

# Ask user which Dockerfile to use
echo ""
echo "Choose Dockerfile version:"
echo "1) Standard optimized (Dockerfile)"
echo "2) Alternative with OpenJDK (Dockerfile.alternative)"
echo "3) Minimal Ubuntu (Dockerfile.minimal)"
echo "4) Ultra optimized (Dockerfile.optimized)"
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo "🐳 Building with standard optimized Dockerfile..."
        docker build -t invitation-app:optimized .
        ;;
    2)
        echo "🐳 Building with alternative Dockerfile..."
        docker build -f Dockerfile.alternative -t invitation-app:alternative .
        ;;
    3)
        echo "🐳 Building with minimal Dockerfile..."
        docker build -f Dockerfile.minimal -t invitation-app:minimal .
        ;;
    4)
        echo "🐳 Building with ultra optimized Dockerfile..."
        docker build -f Dockerfile.optimized -t invitation-app:ultra .
        ;;
    *)
        echo "Invalid choice. Using minimal Dockerfile..."
        docker build -f Dockerfile.minimal -t invitation-app:minimal .
        ;;
esac

# Show image size
echo "📊 Image size information:"
docker images invitation-app:* --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

echo "✅ Build completed successfully!"
echo ""
echo "To run locally:"
echo "docker run -p 8080:8080 invitation-app:minimal"
echo ""
echo "To push to Railway:"
echo "railway up" 