import paramiko
import sys
import time

# Mapeo de entradas PLC a pines GPIO en Raspberry Pi
MAPEO_PLC_A_GPIO = {
    "%IX0.0": 17,
    "%IX0.1": 18,
    "%IX0.2": 27,
    "%IX0.3": 22,
    "%IX0.4": 23,
    "%IX0.5": 24,
}

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
        print("Uso: python script.py <IP_Raspberry> <Clave_ssh> <Clave_ssh_password> <Usuario> <Entrada_PLC>")
        sys.exit(1)

    ip_raspberry = sys.argv[1]
    clave_ssh = sys.argv[2]
    clave_ssh_password = sys.argv[3]
    usuario = sys.argv[4]
    entrada_plc = sys.argv[5]  # %IX0.4 por ejemplo

    # Verificar si la entrada PLC existe en el mapeo
    if entrada_plc not in MAPEO_PLC_A_GPIO:
        print(f"Error: La entrada PLC '{entrada_plc}' no está mapeada a un GPIO.")
        sys.exit(1)

    gpio_pin = MAPEO_PLC_A_GPIO[entrada_plc]

    print(f"Conectando a {ip_raspberry} para mantener la entrada {entrada_plc} (GPIO {gpio_pin}) en 1...")

    # Bucle infinito para mantener siempre el GPIO en 1
    try:
        while True:
            comando = f"gpio -g write {gpio_pin} 1"
            salida, error = ejecutar_comando_ssh(ip_raspberry, usuario, clave_ssh, clave_ssh_password, comando)

            if error:
                print(f"Error al escribir en GPIO {gpio_pin}: {error}")
            else:
                print(f"GPIO {gpio_pin} (Entrada {entrada_plc}) mantenido en 1.")

            time.sleep(5)  # Repite cada 5 segundos para evitar consumo excesivo de CPU
    except KeyboardInterrupt:
        print("\nSaliendo...")

if __name__ == "__main__":
    main()
