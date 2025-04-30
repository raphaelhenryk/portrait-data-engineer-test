#!/bin/bash

# Define log file path
LOGFILE="/var/log/user_data.log"

# Create log file and redirect all output
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== User Data Script Started at $(date)====="

# Update system
echo "Updating system..."

sudo apt update -y
sudo apt upgrade -y

# Install Docker
echo "Installing Docker..."
sudo apt install -y docker.io

# Enable and Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add Ubuntu user to Docker group
echo "create new grwoup docker and add user to Docker group"
newgrp docker
sudo usermod -aG docker ubuntu
sudo usermod -aG docker $USER

# Install git
echo "Installing Git..."
sudo apt install -y git

# Clone your GitHub repo
echo "Cloning Git repository..."
cd /home/ubuntu
git clone https://github.com/raphaelhenryk/portrait-data-engineer-test.git
cd portrait-data-engineer-test

# Change permissions
echo "Changing Permissions"
sudo chown -R ubuntu:ubuntu /home/ubuntu/portrait-data-engineer-test

# Start Docker Compose (for Airflow, dbt, Postgres)
echo "Starting Docker Compose..."
cd docker
docker-compose build --no-cache
docker-compose -f docker-compose.yml up -d


echo "===== User Data Script Completed at $(date) ====="