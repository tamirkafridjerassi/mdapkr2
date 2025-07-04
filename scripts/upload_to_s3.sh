#!/bin/bash

# Load bucket name from output
BUCKET_NAME=$(terraform -chdir=../infra output -raw frontend_bucket)

echo "Uploading index.html to bucket: $BUCKET_NAME"

aws s3 cp ../frontend/index.html s3://$BUCKET_NAME/index.html --content-type text/html

echo "Done. Access the site at:"
echo "http://$BUCKET_NAME.s3-website-ap-south-1.amazonaws.com"
