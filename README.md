# Linux Mint Development Environment Setup

This repository contains a shell script to set up a Linux Mint development environment with tools for PHP, Node.js, Golang, Docker, and Docker Compose.

## What Does It Install?

- **Base Development Tools**: git, vim, curl, wget, build-essential
- **Git Configuration**: Sets up git user name, email, and basic settings
- **SSH Key Generation**: Creates and configures SSH keys for secure authentication
- **ZSH with Oh My ZSH**: Configures ZSH with popular plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - fast-syntax-highlighting
  - zsh-autocomplete
- **Terminal Enhancement**: 
  - Warp Terminal (AI-powered terminal)
- **Node.js Ecosystem**: 
  - Node Version Manager (NVM) with latest LTS version
  - Package Managers: npm, yarn, pnpm, bun
  - Tools: npx, Supabase CLI
- **PHP Ecosystem**:
  - PHP 8.x with common extensions
  - Composer
  - Laravel CLI
  - Symfony CLI
- **Golang**: Latest stable version
- **Docker & Docker Compose**: Latest stable versions
- **Code Editors**: 
  - Visual Studio Code
  - Cursor Editor
- **Database Tools**: SQLite, Redis, MariaDB client, PostgreSQL client

## Usage on Linux Mint

1. Clone this repository
2. Make the script executable: `chmod +x setup_dev_environment.sh`
3. Run the script: `./setup_dev_environment.sh`
4. You'll be prompted for your Git user name, email, and SSH key information
5. Log out and log back in for ZSH, Docker group, and other changes to take effect

## Testing with Docker (for Mac/Windows Users)

If you're on a Mac or Windows and want to test the script before using it on a Linux Mint machine:

1. Make sure Docker Desktop is installed and running
2. Run: `docker-compose up -d`
3. Connect to the container: `docker exec -it linuxmint-dev bash`
4. Inside the container, run: `./setup_dev_environment.sh`

## Customization

Feel free to modify the `setup_dev_environment.sh` script to add or remove packages based on your specific development needs. 