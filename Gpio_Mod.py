import paramiko
import sys

def ejecutar_comando_ssh(host, usuario, clave_ssh, clave_ssh_password, comando):
    try:
        cliente = paramiko.SSHClient()
        cliente.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Cargar la clave privada con su contrase  a
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
    if len(sys.argv) != 4:
        print("Uso: python script.py <IP_Raspberry> <GPIO_PIN> <clave_ssh_password>")
        sys.exit(1)

    ip_raspberry = sys.argv[1]
    gpio_pin = sys.argv[2]
    usuario = "alejandro"  # Cambia esto si usas otro usuario
    clave_ssh = "/home/alejandro/.ssh/id_rsa"
    clave_ssh_password = sys.argv[3]  # La contrase  a de la clave privada

    comando = f"gpio mode {gpio_pin} out && gpio write {gpio_pin} 0"

    print(f"Conectando a {ip_raspberry} para forzar GPIO {gpio_pin} a 0...")

    salida, error = ejecutar_comando_ssh(ip_raspberry, usuario, clave_ssh, clave_ssh_password, comando)

    if error:
        print(f"Error: {error}")
    else:
        print(f"GPIO {gpio_pin} en {ip_raspberry} forzado a 0.")

    # Mantener la ejecuci  n
    try:
        while True:
            ejecutar_comando_ssh(ip_raspberry, usuario, clave_ssh, clave_ssh_password, f"gpio write {gpio_pin} 0")
    except KeyboardInterrupt:
        print("\nSaliendo...")

if __name__ == "__main__":
    main()
