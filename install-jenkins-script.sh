#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (or use sudo)."
  exit 1
fi

echo "Updating system packages..."
apt update && apt upgrade -y

echo "Removing older Java versions (if any)..."
apt remove --purge openjdk-11-jdk -y || echo "Java 11 not found, skipping removal."
apt autoremove -y

echo "Installing OpenJDK 17..."
apt install openjdk-17-jdk -y
if java -version 2>&1 | grep -q "17"; then
    echo "Java 17 installed successfully."
else
    echo "Java installation failed. Exiting."
    exit 1
fi

echo "Adding Jenkins repository and GPG key..."
apt install -y curl
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "Adding Jenkins repository to sources list..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Updating package list with Jenkins repository..."
apt update

echo "Installing Jenkins..."
apt install -y jenkins

echo "Starting and enabling Jenkins service..."
systemctl start jenkins
systemctl enable jenkins

echo "Verifying Jenkins status..."
if systemctl status jenkins | grep -q "active (running)"; then
    echo "Jenkins installed and running successfully."
else
    echo "Jenkins installation failed. Check logs for details."
    exit 1
fi

echo "Fetching initial admin password..."
ADMIN_PASSWORD=$(cat /var/lib/jenkins/secrets/initialAdminPassword)

echo "Installation complete."
echo "Access Jenkins at: http://<your-server-ip>:8080"
echo "Initial admin password: $ADMIN_PASSWORD"
