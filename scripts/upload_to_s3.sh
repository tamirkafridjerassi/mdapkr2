#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# Run full deploy
echo "🚀 Running Terraform and Lambda deployment..."
./scripts/deploy_all.sh

cd "$ROOT_DIR/infra"
BUCKET=$(terraform output -raw frontend_bucket)

if [ -z "$BUCKET" ]; then
  echo "❌ Could not retrieve frontend bucket name."
  exit 1
fi

INDEX_FILE="$ROOT_DIR/frontend/index.html"
CONFIG_FILE="$ROOT_DIR/backend/build/config.json"

if [ ! -f "$INDEX_FILE" ]; then
  echo "❌ index.html not found at $INDEX_FILE"
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ config.json not found at $CONFIG_FILE"
  exit 1
fi

echo "📦 Uploading index.html to bucket: $BUCKET"
aws s3 cp "$INDEX_FILE" s3://$BUCKET/index.html --content-type "text/html"

echo "📦 Uploading config.json to bucket: $BUCKET"
aws s3 cp "$CONFIG_FILE" s3://$BUCKET/config.json --content-type "application/json"

echo "✅ Upload complete. Access the site at:"
echo "http://$BUCKET.s3-website.ap-south-1.amazonaws.com"
