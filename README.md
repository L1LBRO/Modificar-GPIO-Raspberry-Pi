# Raspberry Pi GPIO Control Scripts

This repository contains a collection of Bash and Python scripts designed to modify the GPIO pins of a Raspberry Pi via SSH, allowing remote device control or simulation of manipulation attacks.

## Project Description

### The project includes:

#### A Bash script (`Configuracion_previa_ssh.sh`):

- Configures the Raspberry Pi.
- Generates SSH keys for passwordless authentication.
- Transfers the SSH keys to the Raspberry Pi.
- Installs required dependencies (WiringPi, Paramiko).
- Executes the Python script responsible for GPIO modification.

#### A Python script (`Gpio_Mod_unica_salida.py`):

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
curl -sL https://raw.githubusercontent.com/L1LBRO/Modificar-GPIO-Raspberry-Pi/main/Configuracion_previa_ssh.sh \
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
