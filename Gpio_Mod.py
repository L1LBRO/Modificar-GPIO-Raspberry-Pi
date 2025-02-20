import paramiko
import sys
import time

def ejecutar_comando_ssh(host, usuario, clave_ssh, clave_ssh_password, comando):
    try:
        cliente = paramiko.SSHClient()
        cliente.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # Cargar clave privada con su contraseña
        clave = paramiko.RSAKey.from_private_key_file(clave_ssh, password=clave_ssh_password)
        
        # Conectar a la Raspberry Pi
        cliente.connect(host, username=usuario, pkey=clave)

        # Ejecutar el comando
        stdin, stdout, stderr = cliente.exec_command(comando)
        salida = stdout.read().decode()
        error = stderr.read().decode()

        cliente.close()
        return salida, error
    except Exception as e:
        return None, str(e)

def main():
    if len(sys.argv) != 6:
        print("Uso: python script.py <IP_Raspberry> <Clave_ssh> <Clave_ssh_password> <Usuario> <Gpio_Pin>")
        sys.exit(1)

    ip_raspberry = sys.argv[1]
    clave_ssh = sys.argv[2]
    clave_ssh_password = sys.argv[3]
    usuario = sys.argv[4]
    gpio_pin = sys.argv[5]

    # Comando inicial para configurar el GPIO y ponerlo en 1
    comando = f"gpio mode {gpio_pin} out && gpio write {gpio_pin} 1"

    print(f"Conectando a {ip_raspberry} para forzar GPIO {gpio_pin} a 1...")

    # Ejecutar el comando
    salida, error = ejecutar_comando_ssh(ip_raspberry, usuario, clave_ssh, clave_ssh_password, comando)

    if error:
        print(f"Error: {error}")
        sys.exit(1)
    else:
        print(f"GPIO {gpio_pin} en {ip_raspberry} forzado a 1.")

    # Mantener la ejecución enviando el comando cada 5 segundos
    try:
        while True:
            salida, error = ejecutar_comando_ssh(ip_raspberry, usuario, clave_ssh, clave_ssh_password, f"gpio write {gpio_pin} 0")
            
            if error:
                print(f"Error al intentar escribir en GPIO {gpio_pin}: {error}")
            else:
                print(f"GPIO {gpio_pin} puesto en 0.")

            time.sleep(5)  # Espera 5 segundos antes de repetir
    except KeyboardInterrupt:
        print("\nSaliendo...")

if __name__ == "__main__":
    main()
