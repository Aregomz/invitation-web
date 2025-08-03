# Optimized Deployment Guide

## Problem
The original deployment was failing because the Docker image size (4.2GB) exceeded Railway's 4GB limit.

## Solution
We've implemented several optimizations to reduce the image size:

### 1. Multi-stage Docker Build
- Uses a pre-built Flutter image (`cirrusci/flutter:3.19.0`) for building
- Final stage only contains the built web files and nginx
- Reduces image size significantly

### 2. Optimized Dependencies
- Uses Alpine Linux for the final stage
- Removed unnecessary packages and caches
- Simplified build process

### 3. Flutter Build Optimizations
- Uses HTML renderer instead of CanvasKit
- Disables tree-shaking for icons
- Disables Skia for web rendering

## Files Changed

### `Dockerfile`
- Uses `cirrusci/flutter:3.19.0` base image
- Multi-stage build with Alpine production
- Avoids `flutter doctor` issues
- Proper layer caching

### `nginx.conf`
- Optimized nginx configuration
- Gzip compression enabled
- Proper caching headers
- Security headers

### `railway.json` & `railway.toml`
- Changed from Nixpacks to Dockerfile builder
- Added deployment configuration
- Health check configuration

### `.dockerignore`
- Excludes unnecessary files from build context
- Reduces build time and image size

## Deployment Steps

### Option 1: Use the optimized build script
```bash
./build-optimized.sh
```

### Option 2: Manual deployment
```bash
# Build the Docker image
docker build -t invitation-app:optimized .

# Check image size
docker images invitation-app:optimized

# Deploy to Railway
railway up
```

### Option 3: Direct Railway deployment
```bash
# Deploy directly to Railway (will build on Railway's servers)
railway up
```

## Expected Results
- Image size should be under 1GB (down from 4.2GB)
- Faster build times
- Better performance with nginx serving static files
- No more `flutter doctor` errors

## Troubleshooting

### If image is still too large:
1. Check if all unnecessary files are excluded in `.dockerignore`
2. Verify that the multi-stage build is working correctly
3. Consider using the ultra-optimized `Dockerfile.optimized`

### If build fails with flutter doctor:
1. The new Dockerfile uses a pre-built Flutter image
2. This should resolve all `flutter doctor` issues
3. If still failing, check Railway logs for specific errors

### If Railway deployment fails:
1. Ensure Docker Desktop is running (for local testing)
2. Check Railway logs for specific error messages
3. Verify that all required files are present

## Monitoring
- Use `docker images` to check image size
- Monitor Railway logs for deployment status
- Check application performance after deployment
- Verify health check endpoint at `/`

## Alternative Dockerfiles
- `Dockerfile.simple`: Uses pre-built Flutter image (recommended)
- `Dockerfile.optimized`: Ultra-optimized version with security features
- `Dockerfile`: Standard optimized version 