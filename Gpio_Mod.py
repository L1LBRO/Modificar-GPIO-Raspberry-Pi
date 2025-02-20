import paramiko
import sys
import time

def ejecutar_comando_ssh(host, usuario, clave_ssh, clave_ssh_password, comando):
    try:
        cliente = paramiko.SSHClient()
        cliente.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        clave = paramiko.RSAKey.from_private_key_file(clave_ssh, password=clave_ssh_password)
        
        cliente.connect(host, username=usuario, pkey=clave)

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

    print(f"Conectando a {ip_raspberry} para mantener GPIO {gpio_pin} en 1...")

    # Bucle infinito para mantener siempre el GPIO en 1
    try:
        while True:
            comando = f"gpio -g write {gpio_pin} 1"
            salida, error = ejecutar_comando_ssh(ip_raspberry, usuario, clave_ssh, clave_ssh_password, comando)

            if error:
                print(f"Error al escribir en GPIO {gpio_pin}: {error}")
            else:
                print(f"GPIO {gpio_pin} mantenido en 1.")

            time.sleep(5)  # Repite cada 5 segundos para evitar consumo excesivo de CPU
    except KeyboardInterrupt:
        print("\nSaliendo...")

if __name__ == "__main__":
    main()
