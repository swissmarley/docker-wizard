# docker-wizard

![alt text](https://github.com/swissmarley/docker-wizard/blob/main/UI_Menu.png?raw=true)

## Overview

Docker Wizard is a streamlined Bash shell script designed to facilitate the management of Docker containers. It provides a user-friendly command-line interface to handle container operations efficiently.

## Features

- **Container Management**: 
  - Build a container from scratch
  - Start, stop, and remove containers.
  - List all containers (running and stopped).
  - Display container logs.
  - Inspect container details.
  - Execute commands inside a running container.
- **Image Management**:
  - Pull Docker images from a repository.
  - Push Docker images to a repository.
  - Remove Docker images.
  - List all Docker images.
- **General Docker Information**:
  - Display Docker system information.

## Prerequisites

- Docker installed on your system.
- Bash shell environment.

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/swissmarley/docker-wizard.git
   cd docker-wizard
   ```

2. Make the script executable:
   ```sh
   chmod +x docker-wizard.sh
   ```

## Usage

Run the script to open the interactive menu:
```sh
./docker-wizard.sh
```

Follow the on-screen instructions to manage your Docker containers and images.

## Contributing

We welcome contributions! Please fork the repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
