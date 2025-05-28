#!/bin/bash
# Install Docker if not already installed
if ! command -v docker &> /dev/null
then
    echo "Docker not found, installing..."
    sudo yum update -y
    sudo yum install -y docker
    sudo service docker start
    sudo usermod -a -G docker ec2-user # Add ec2-user to docker group
    echo "Docker installed successfully."
else
    echo "Docker is already installed."
fi

