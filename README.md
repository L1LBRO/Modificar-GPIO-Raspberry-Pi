# Raspberry Pi GPIO Control Scripts

This repository contains a collection of Bash and Python scripts designed to modify the GPIO pins of a Raspberry Pi via SSH, allowing remote device control or simulation of manipulation attacks.

## Project Description

### The project includes:

#### A Bash script (`ssh_preconfig.sh`):

- Configures the Raspberry Pi.
- Generates SSH keys for passwordless authentication.
- Transfers the SSH keys to the Raspberry Pi.
- Installs required dependencies (WiringPi, Paramiko).
- Executes the Python script responsible for GPIO modification.

#### A Python script (`Gpio_Mod_exit.py`):

- Connects to the Raspberry Pi via SSH.
- Modifies GPIO pins based on a specified PLC input.
- Keeps the output in a high state (1) continuously.

## Requirements

### Hardware

- Raspberry Pi (any model with functional GPIO)
- Controlled device (e.g., LED, relay, motor, etc.)

### Software and dependencies

- Raspbian OS (or any compatible Linux distribution)
- Python 3.x

#### Required packages

- `paramiko` (for SSH connection in Python)
- `sshpass` (for automating SSH authentication in Bash)
- `WiringPi` (for GPIO manipulation on Raspberry Pi)

## Usage

### Pre-configuration on the Raspberry Pi

Before running the scripts, make sure to:

- Enable SSH access on the Raspberry Pi.
- Create a user with SSH access permissions.
- Configure the proper GPIO access permissions.

### Running the Pre-Configuration Script

To automatically set up everything, run the following command from another Linux machine:

```bash
curl -sL https://raw.githubusercontent.com/L1LBRO/Modify-GPIO-Raspberry-Pi/refs/heads/main/ssh_preconfig.sh \
| sudo bash -s <Raspberry_IP> <Passphrase> <User> <PLC_Input> <Raspberry_Password>
````
Where

| Parameter              | Description                                         |
| ---------------------- | --------------------------------------------------- |
| `<Raspberry_IP>`       | IP address of the Raspberry Pi                      |
| `<Passphrase>`         | Security phrase for the SSH key                     |
| `<User>`               | Raspberry Pi username                               |
| `<PLC_Input>`          | PLC input associated with the GPIO (e.g., `%IX0.4`) |
| `<Raspberry_Password>` | Password of the Raspberry Pi user                   |

## PLC Input to GPIO Mapping

| PLC Input | Raspberry GPIO |
| :-------: | :------------: |
|   %IX0.0  |     GPIO 17    |
|   %IX0.1  |     GPIO 18    |
|   %IX0.2  |     GPIO 27    |
|   %IX0.3  |     GPIO 22    |
|   %IX0.4  |     GPIO 23    |
|   %IX0.5  |     GPIO 24    |

## Notes

The script keeps the GPIO state set to 1 indefinitely, checking every 5 seconds.
To stop the process, press Ctrl + C.
It is recommended to test with an LED before connecting higher-power devices.

## Contributions

If you want to improve this project, fork the repository and submit a pull request with your enhancements.

## Disclaimer

This project is intended for educational and auditing purposes in controlled environments only.
It must not be used for malicious activities or in production systems without explicit authorization.

## License

This project is licensed under the MIT License

