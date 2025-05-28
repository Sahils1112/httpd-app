#!/bin/bash
# Stop the running Docker container
CONTAINER_NAME="httpd-container"
echo "Stopping container ${CONTAINER_NAME}..."
docker stop ${CONTAINER_NAME} || true
echo "Container stopped."
