#!/bin/bash
set -e

# Resolve the root directory
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Move into infra
cd "$ROOT_DIR/infra"

echo "🚀 Running Terraform Apply..."
terraform init
terraform apply -auto-approve -var="suffix=8fe57af2"

# Get the API URL
API_URL=$(terraform output -raw api_url)

# Generate config.json
echo "🛠️ Generating config.json with API URL: $API_URL"
mkdir -p "$ROOT_DIR/backend/build"
echo "{\"api_url\": \"$API_URL\"}" > "$ROOT_DIR/backend/build/config.json"
