#!/bin/bash

# Update system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Wait for Docker
sleep 20

# Add user to docker group
sudo usermod -aG docker ubuntu

# Install AWS CLI
sudo apt-get install -y curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip -q awscliv2.zip
sudo ./aws/install --update

# Wait a bit
sleep 10

# Get variables from Terraform
ECR_REPO="${ecr_repo}"
IMAGE_TAG="${image_tag}"
AWS_REGION="${aws_region}"

# ✅ **GENERATE ALL REQUIRED STRAPI SECRETS**
ADMIN_JWT_SECRET=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
API_TOKEN_SALT=$(openssl rand -base64 32)
# ✅ **APP_KEYS MUST BE COMMA-SEPARATED LIST**
APP_KEYS="$(openssl rand -base64 32),$(openssl rand -base64 32),$(openssl rand -base64 32),$(openssl rand -base64 32)"

echo "Generated Secrets:"
echo "APP_KEYS: $APP_KEYS"
echo "ADMIN_JWT_SECRET: $ADMIN_JWT_SECRET"
echo "JWT_SECRET: $JWT_SECRET"

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | sudo docker login --username AWS --password-stdin $ECR_REPO

# Pull Docker image
sudo docker pull $ECR_REPO:$IMAGE_TAG

# Stop old container
sudo docker stop strapi-app 2>/dev/null || true
sudo docker rm strapi-app 2>/dev/null || true

# ✅ **RUN STRAPI WITH ALL REQUIRED ENV VARIABLES**
sudo docker run -d \
  --name strapi-app \
  -p 1337:1337 \
  --restart unless-stopped \
  -e NODE_ENV=production \
  -e APP_KEYS="$APP_KEYS" \
  -e JWT_SECRET="$JWT_SECRET" \
  -e ADMIN_JWT_SECRET="$ADMIN_JWT_SECRET" \
  -e API_TOKEN_SALT="$API_TOKEN_SALT" \
  $ECR_REPO:$IMAGE_TAG

# Check status
echo "Checking container status..."
sleep 30
sudo docker ps

# Check logs
echo "Container logs:"
sudo docker logs --tail 20 strapi-app

# Create simple log
echo "Deployment completed at $(date)" > /home/ubuntu/deploy.log
echo "ECR Repo: $ECR_REPO" >> /home/ubuntu/deploy.log
echo "Image Tag: $IMAGE_TAG" >> /home/ubuntu/deploy.log
echo "APP_KEYS: $APP_KEYS" >> /home/ubuntu/deploy.log

# Get public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "unknown")

echo ""
echo "========================================"
echo "Deployment attempt complete!"
echo "Public IP: $PUBLIC_IP"
echo "Strapi URL: http://$PUBLIC_IP:1337"
echo "Admin Panel: http://$PUBLIC_IP:1337/admin"
echo "Check logs: /home/ubuntu/deploy.log"
echo "========================================"