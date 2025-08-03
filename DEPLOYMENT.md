# Optimized Deployment Guide

## Problem
The original deployment was failing because the Docker image size (4.2GB) exceeded Railway's 4GB limit.

## Solution
We've implemented several optimizations to reduce the image size:

### 1. Multi-stage Docker Build
- Uses Ubuntu 22.04 for building Flutter
- Final stage only contains the built web files and nginx
- Reduces image size significantly

### 2. Optimized Dependencies
- Uses Alpine Linux for the final stage
- Minimal dependencies installation
- Cleaned up package caches

### 3. Flutter Build Optimizations
- Uses HTML renderer instead of CanvasKit
- Disables tree-shaking for icons
- Disables Skia for web rendering

## Files Changed

### `Dockerfile`
- Uses Ubuntu 22.04 base image
- Multi-stage build with Alpine production
- Minimal dependency installation
- Proper layer caching

### `nginx.conf`
- Optimized nginx configuration
- Gzip compression enabled
- Proper caching headers
- Security headers

### `railway.json`
- Changed from Nixpacks to Dockerfile builder
- Simplified deployment configuration

### `.dockerignore`
- Excludes unnecessary files from build context
- Reduces build time and image size

## Deployment Steps

### Option 1: Direct Railway deployment (Recommended)
```bash
# Install Railway CLI if not installed
npm install -g @railway/cli

# Login to Railway
railway login

# Deploy directly
railway up
```

### Option 2: Use the deployment script
```bash
./deploy.sh
```

### Option 3: Manual deployment
```bash
# Build the Docker image locally (if Docker is available)
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
- No more image not found errors

## Troubleshooting

### If Railway deployment fails:
1. Check Railway logs for specific error messages
2. Ensure all required files are present
3. Verify Railway CLI is installed and logged in

### If image is still too large:
1. Check if all unnecessary files are excluded in `.dockerignore`
2. Verify that the multi-stage build is working correctly
3. Consider using the ultra-optimized `Dockerfile.optimized`

### If build fails with image not found:
1. The new Dockerfile uses Ubuntu 22.04 which is always available
2. This should resolve all image availability issues
3. If still failing, check Railway logs for specific errors

## Monitoring
- Monitor Railway logs for deployment status
- Check application performance after deployment
- Verify the application is accessible at the provided URL

## Alternative Dockerfiles
- `Dockerfile.minimal`: Minimal Ubuntu-based build (current)
- `Dockerfile.alternative`: Uses OpenJDK base image
- `Dockerfile.optimized`: Ultra-optimized version with security features

## Quick Start
1. Install Railway CLI: `npm install -g @railway/cli`
2. Login: `railway login`
3. Deploy: `railway up`
4. Check your app at the provided URL 