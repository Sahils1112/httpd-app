#!/bin/bash
set -euo pipefail

export REGION="ap-south-1"

echo "Fetching deployment parameters from SSM..."
export ACCOUNT_ID=$(aws ssm get-parameter --name "/httpd-app/ecr/account-id" --with-decryption --query "Parameter.Value" --output text --region ${REGION})
export REPO_NAME=$(aws ssm get-parameter --name "/httpd-app/ecr/repo-name" --with-decryption --query "Parameter.Value" --output text --region ${REGION})

DOCKER_IMAGE_NAME="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest"
CONTAINER_NAME="httpd-container"

echo "Account ID: ${ACCOUNT_ID}"
echo "Repo Name: ${REPO_NAME}"
echo "Region: ${REGION}"

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
