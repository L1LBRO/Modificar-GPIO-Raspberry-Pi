#!/bin/bash

# Este script es la configuración previa antes de realizar el ataque simulado de modificar el GPIO de la Raspberry Pi

# Ejecución del Script

  # curl -sL https://raw.githubusercontent.com/L1LBRO/Modificar-GPIO-Raspberry-Pi/refs/heads/main/Configuracion_previa_ssh.sh | sudo bash 

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

  
  if [ $# -ne 3 ]; then
    echo "Uso: $0 <IP> <Passphrase> <Usuario>"
  exit 1
  fi

  # Parámetros
  vIpRaspberry = $1
  vPassp = $2 
  vUser = $3
  # Generación de claves ssh
  echo ""
  echo " Generando las claves ssh para conectarse a la Raspberry.... "
  echo ""


  # Archivo de las claves
  vKey_Name="${HOME}/.ssh/id_rsa"
  
  if [ -f "$vKey_Name" ]; then
    echo "La clave SSH ya existe en $vKey_Name."
  exit 1
  fi
  
  ssh-keygen -t rsa -b 4096 -f "$vKey_Name" -C "$vUser@$vIpRaspberry" -N "$PASSPHRASE"

  if [ $? -eq 0 ]; then
    echo "Clave SSH generada exitosamente en $vKey_Name."
  else
    echo "Hubo un error al generar la clave SSH."
  exit 1
  fi


  echo ""
  echo " Enviando las claves SSH a la máquina victima.... "
  echo ""

  sudo apt install sshpass -y 

  
  sudo sshpass -p $vPassp ssh-copy-id -i $vKey_Name $vUser@$vIpRaspberry

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
  
  gpio -v

  echo ""
  echo " Instalando Paramiko.... "
  echo ""

  sudo apt install pyhton3-paramiko -y 

  if [ $? -eq 0 ]; then
    echo "Paquete Paramiko instalado correctamente."
  else
    echo "Hubo un error al instalar el paquete Paramiko."
  exit 1
  fi
  
  curl -sL 
    
















  
