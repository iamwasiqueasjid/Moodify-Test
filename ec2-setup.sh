#!/bin/bash

##############################################################################
# EC2 Instance Setup Script for Jenkins CI/CD Pipeline
# This script installs and configures Jenkins, Docker, and dependencies
##############################################################################

set -e  # Exit on any error

echo "=========================================="
echo "Starting EC2 Setup for Jenkins Pipeline"
echo "=========================================="

# Update system packages
echo "[1/9] Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Java (required for Jenkins)
echo "[2/9] Installing OpenJDK 17..."
sudo apt-get install -y openjdk-17-jdk

# Verify Java installation
java -version

# Install Jenkins
echo "[3/9] Installing Jenkins..."
# Add Jenkins repository key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list and install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Start and enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Docker
echo "[4/9] Installing Docker..."
# Install prerequisites
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add Jenkins user to Docker group
echo "[5/9] Configuring Docker permissions for Jenkins..."
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu

# Restart Jenkins to apply group changes
sudo systemctl restart jenkins

# Install Git
echo "[6/9] Installing Git..."
sudo apt-get install -y git

# Install additional utilities
echo "[7/9] Installing additional utilities..."
sudo apt-get install -y \
    wget \
    curl \
    unzip \
    vim \
    htop

# Configure firewall (if UFW is enabled)
echo "[8/9] Configuring firewall..."
if sudo ufw status | grep -q "Status: active"; then
    echo "UFW is active, opening port 8080 for Jenkins..."
    sudo ufw allow 8080/tcp
    sudo ufw reload
else
    echo "UFW is not active. Make sure port 8080 is open in AWS Security Groups."
fi

# Get Jenkins initial admin password
echo "[9/9] Retrieving Jenkins initial admin password..."
sleep 10  # Wait for Jenkins to fully start
echo "=========================================="
echo "Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "=========================================="

# Display service status
echo ""
echo "Service Status:"
echo "---------------"
sudo systemctl status jenkins --no-pager | head -n 5
sudo systemctl status docker --no-pager | head -n 5

# Get EC2 public IP
EC2_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo "Jenkins URL: http://$EC2_IP:8080"
echo ""
echo "Next Steps:"
echo "1. Access Jenkins at the URL above"
echo "2. Use the initial admin password shown above"
echo "3. Install suggested plugins"
echo "4. Create admin user"
echo "5. Run jenkins-config.sh to complete configuration"
echo "=========================================="
