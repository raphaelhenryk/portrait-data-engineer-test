#!/bin/bash
# Update system
sudo apt update -y
sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io

# Enable and Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add Ubuntu user to Docker group
sudo usermod -aG docker ubuntu

# Install git
sudo apt install -y git

# Clone your GitHub repo
cd /home/ubuntu
git clone https://github.com/raphaelhenryk/portrait-data-engineer-test.git
cd portrait-data-engineer-test

# Change permissions
sudo chown -R ubuntu:ubuntu /home/ubuntu/portrait-data-engineer-test

# Start Docker Compose (for Airflow, dbt, Postgres)
docker-compose -f docker/docker-compose.yml up -d