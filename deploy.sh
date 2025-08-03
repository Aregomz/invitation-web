#!/bin/bash
set -e

echo "🚀 Deploying to Railway..."

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI is not installed. Please install it first:"
    echo "npm install -g @railway/cli"
    exit 1
fi

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo "❌ Please login to Railway first:"
    echo "railway login"
    exit 1
fi

echo "📦 Building and deploying to Railway..."
railway up

echo "✅ Deployment completed!"
echo ""
echo "Your app should be available at the URL provided by Railway."
echo "Check the Railway dashboard for the deployment status." 