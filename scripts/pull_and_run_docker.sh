#!/bin/bash
set -euo pipefail

# Temporarily hardcode region for testing. REMOVE FOR PRODUCTION!
export REGION="ap-south-1" # <--- Replace with your actual region, e.g., "us-east-1"

echo "Fetching deployment parameters from SSM..."
export ACCOUNT_ID=$(aws ssm get-parameter --name "/httpd-app/ecr/account-id" --with-decryption --query "Parameter.Value" --output text)
# REGION is now set, so the next line will succeed if the parameter exists.
# export REGION=$(aws ssm get-parameter --name "/httpd-app/ecr/region" --with-decryption --query "Parameter.Value" --output text)
export REPO_NAME=$(aws ssm get-parameter --name "/httpd-app/ecr/repo-name" --with-decryption --query "Parameter.Value" --output text)

DOCKER_IMAGE_NAME="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest"
CONTAINER_NAME="httpd-container"

echo "Stopping existing container (if any)..."
docker stop ${CONTAINER_NAME} || true
docker rm ${CONTAINER_NAME} || true

echo "Logging in to ECR..."
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

echo "Pulling new Docker image: ${DOCKER_IMAGE_NAME}"
docker pull ${DOCKER_IMAGE_NAME}

echo "Running new Docker container..."
docker run -d --name ${CONTAINER_NAME} -p 80:80 ${DOCKER_IMAGE_NAME}

echo "Deployment complete."
