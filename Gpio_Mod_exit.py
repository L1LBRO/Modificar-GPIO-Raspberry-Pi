import paramiko
import sys
import time

# Mapping of PLC inputs to Raspberry Pi GPIO pins
PLC_TO_GPIO_MAP = {
    "%IX0.0": 17,
    "%IX0.1": 18,
    "%IX0.2": 27,
    "%IX0.3": 22,
    "%IX0.4": 23,
    "%IX0.5": 24,
}

def run_ssh_command(host, user, ssh_key, ssh_key_password, command):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        key = paramiko.RSAKey.from_private_key_file(ssh_key, password=ssh_key_password)
        
        client.connect(host, username=user, pkey=key)

        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode()
        error = stderr.read().decode()

        client.close()
        return output, error
    except Exception as e:
        return None, str(e)

def main():
    if len(sys.argv) != 6:
        print("Usage: python script.py <Raspberry_IP> <SSH_Key> <SSH_Key_Password> <User> <PLC_Input>")
        sys.exit(1)

    raspberry_ip = sys.argv[1]
    ssh_key = sys.argv[2]
    ssh_key_password = sys.argv[3]
    user = sys.argv[4]
    plc_input = sys.argv[5]  # e.g. %IX0.4

    # Verify if the PLC input exists in the mapping
    if plc_input not in PLC_TO_GPIO_MAP:
        print(f"Error: PLC input '{plc_input}' is not mapped to a GPIO.")
        sys.exit(1)

    gpio_pin = PLC_TO_GPIO_MAP[plc_input]

    print(f"Connecting to {raspberry_ip} to keep input {plc_input} (GPIO {gpio_pin}) at 1...")

    # Infinite loop to always keep the GPIO at 1
    try:
        while True:
            command = f"gpio -g write {gpio_pin} 1"
            output, error = run_ssh_command(raspberry_ip, user, ssh_key, ssh_key_password, command)

            if error:
                print(f"Error writing to GPIO {gpio_pin}: {error}")
            else:
                print(f"GPIO {gpio_pin} (Input {plc_input}) held at 1.")

            time.sleep(5)  # Repeat every 5 seconds to avoid excessive CPU usage
    except KeyboardInterrupt:
        print("\nExiting...")

if __name__ == "__main__":
    main()
