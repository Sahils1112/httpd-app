#!/bin/bash
# Pull and run the new Docker image
DOCKER_IMAGE_NAME="145023138993.dkr.ecr.ap-south-1.amazonaws.com/httpd-app:latest" # This will be replaced by CodeBuild
CONTAINER_NAME="httpd-container"

echo "Stopping existing container (if any)..."
docker stop ${CONTAINER_NAME} || true
docker rm ${CONTAINER_NAME} || true

echo "Logging in to ECR..."
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 145023138993.dkr.ecr.ap-south-1.amazonaws.com

echo "Pulling new Docker image: ${DOCKER_IMAGE_NAME}"
docker pull ${DOCKER_IMAGE_NAME}

echo "Running new Docker container..."
docker run -d --name ${CONTAINER_NAME} -p 80:80 ${DOCKER_IMAGE_NAME}

echo "Deployment complete."
