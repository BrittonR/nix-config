# Nix Configuration Repository

This repository contains the Nix configuration files for managing various systems. It has been structured to work with the determinate.systems Nix installer.

## Structure

- `hosts/`: Contains configuration files for different hosts.
- `data/`: Stores data related to system-wide configurations.
- `home/`: Contains user-specific home directory configurations.

## Installation

To set up a system using these configuration files, follow these steps:

1. **Download and Install the determinate.systems Nix Installer**: Follow the instructions available at [determinate.systems](https://zero-to-nix.com/start/install) to install the appropriate version of the Nix installer for your system.

2. **Clone this Repository**: Clone this repository to your local machine by running:

   ```
   git clone <repository-url>
   ```

3. **Navigate to the Repository**: Move to the repository's directory:

   ```
   cd <repository-directory>
   ```

4. **Build and Switch Systems**: Utilize the `just` command to build and switch to the desired system configuration:

   ```
   just
   ```

## Usage

- Modify the configurations in the `hosts/`, `data/`, or `home/` directories as required.
- Run the `just` command to build and switch to the newly defined configurations.
