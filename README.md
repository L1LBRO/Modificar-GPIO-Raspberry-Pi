# Raspberry Pi GPIO Control Scripts

Este repositorio contiene un conjunto de scripts en Bash y Python diseñados para modificar los pines GPIO de una Raspberry Pi mediante una conexión SSH, permitiendo controlar dispositivos de forma remota o simular ataques de manipulación.

  ## Descripción del Proyecto

  ### El proyecto incluye:
  
  #### Un script en Bash (Configuracion_previa_ssh.sh):
    
    Configura la Raspberry Pi.
    Genera claves SSH para autenticación sin contraseña.
    Envía las claves SSH a la Raspberry Pi.
    Instala dependencias necesarias (WiringPi, Paramiko).
    Ejecuta el script en Python encargado de modificar los GPIOs.

  #### Un script en Python (Gpio_Mod_unica_salida.py):

    Se conecta a la Raspberry Pi vía SSH.
    Modifica los pines GPIO en función de una entrada de PLC especificada.
    Mantiene la salida en estado alto (1) de manera continua.

  ## Requisitos

  ### Hardware:

    Raspberry Pi (cualquier modelo con GPIO funcional)
    Dispositivo controlado (ejemplo: LED, relay, motor, etc.)

  ### Software y dependencias:
    
    Raspbian OS (o cualquier distribución de Linux compatible)
    Python 3.x
  
  #### Paquetes necesarios:

    paramiko (para conexión SSH en Python)
    sshpass (para automatizar la autenticación SSH en Bash)
    WiringPi (para manipulación de GPIOs en Raspberry Pi)

  ## Uso

  ### Configuración previa en la Raspberry Pi

  Antes de ejecutar los scripts, asegúrate de:

    Tener habilitado el acceso SSH en la Raspberry Pi.
    Crear un usuario con permisos para acceder vía SSH.
    Configurar los permisos adecuados para los pines GPIO.

  ### Ejecución del Script de Configuración Previa

  Para ejecutar el script en modo automático, puedes correr el siguiente comando desde otra máquina Linux:

      curl -sL https://raw.githubusercontent.com/L1LBRO/Modificar-GPIO-Raspberry-Pi/main/Configuracion_previa_ssh.sh | sudo bash -s <IP_Raspberry> <Passphrase> <Usuario> <Entrada_PLC> <RaspberryPass>
      
  Donde

    <IP_Raspberry> → Dirección IP de la Raspberry Pi.
    <Passphrase> → Frase de seguridad para la clave SSH.
    <Usuario> → Usuario de la Raspberry Pi.
    <Entrada_PLC> → Entrada PLC asociada al GPIO (Ej: %IX0.4).
    <RaspberryPass> → Contraseña del usuario en la Raspberry Pi.

  ## Mapeo de Entradas PLC a GPIOs
      
  El script de Python utiliza un mapeo predefinido para asociar entradas de un PLC con los pines GPIO de la Raspberry Pi:
  
  | Entrada PLC | GPIO en Raspberry |
  |     :---:   |       :---:       |
  |  %IX0.0     |  GPIO 17 |
  |  %IX0.1     |  GPIO 18 |
  |  %IX0.2     |  GPIO 27 |
  |  %IX0.3     |  GPIO 22 |
  |  %IX0.4     |  GPIO 23 |
  |  %IX0.5     |  GPIO 24 |

  ## Notas

    El script mantiene el estado del GPIO en 1 indefinidamente, con una verificación cada 5 segundos.
    Para detener el proceso, usa Ctrl + C.
    Se recomienda probar con un LED antes de conectar dispositivos de mayor potencia.

  ## Contribuciones

  Si deseas mejorar este proyecto, haz un fork del repositorio y envía un pull request con tus mejoras.

  ## Nota

  Este proyecto tiene fines educativos y de auditoría en entornos controlados. No debe utilizarse con fines malintencionados ni en sistemas en producción sin autorización.

  ## Licencia

  Este proyecto está bajo la licencia MIT.







