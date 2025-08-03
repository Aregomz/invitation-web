# Optimized Deployment Guide

## Problem
The original deployment was failing because the Docker image size (4.2GB) exceeded Railway's 4GB limit.

## Solution
We've implemented several optimizations to reduce the image size:

### 1. Multi-stage Docker Build
- Uses a builder stage for Flutter compilation
- Final stage only contains the built web files and nginx
- Reduces image size significantly

### 2. Optimized Dependencies
- Removed unnecessary packages from the base image
- Uses Alpine Linux for the final stage
- Cleaned up package caches

### 3. Flutter Build Optimizations
- Uses HTML renderer instead of CanvasKit
- Disables tree-shaking for icons
- Disables Skia for web rendering

## Files Changed

### `Dockerfile`
- Multi-stage build with Ubuntu builder and Alpine production
- Optimized dependency installation
- Proper layer caching

### `nginx.conf`
- Optimized nginx configuration
- Gzip compression enabled
- Proper caching headers
- Security headers

### `railway.json`
- Changed from Nixpacks to Dockerfile builder
- Added deployment configuration

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

## Expected Results
- Image size should be under 1GB (down from 4.2GB)
- Faster build times
- Better performance with nginx serving static files

## Troubleshooting

### If image is still too large:
1. Check if all unnecessary files are excluded in `.dockerignore`
2. Verify that the multi-stage build is working correctly
3. Consider using the ultra-optimized `Dockerfile.optimized`

### If build fails:
1. Ensure Docker is running
2. Check that all required files are present
3. Verify Flutter installation

## Monitoring
- Use `docker images` to check image size
- Monitor Railway logs for deployment status
- Check application performance after deployment 