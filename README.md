# Linux Mint Development Environment Setup

This repository contains a shell script to set up a Linux Mint development environment with tools for PHP, Node.js, Golang, Docker, and Docker Compose.

## What Does It Install?

### System & Security
- **Base Development Tools**: git, vim, curl, wget, build-essential
- **Security Tools**: ufw (firewall), fail2ban (SSH protection)
- **Monitoring & Utility**: htop, glances, ncdu, fzf, ripgrep, bat, jq

### Version Control & SSH
- **Git Configuration**: Sets up git user name, email, and basic settings
- **SSH Key Generation**: Creates and configures SSH keys for secure authentication
- **SSH Backup**: Automatically backs up SSH keys

### Terminal & Shell
- **ZSH with Oh My ZSH**: Configures ZSH with Powerlevel10k theme and powerful plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - fast-syntax-highlighting
  - zsh-autocomplete
  - fzf-tab
  - forgit (git utilities)
  - and many more
- **Terminal Enhancements**: 
  - Warp Terminal (AI-powered terminal)
  - Kitty Terminal (GPU-accelerated alternative)
- **Programming Fonts**:
  - Fira Code
  - JetBrains Mono
  - Cascadia Code

### Development Environments
- **Node.js Ecosystem**: 
  - Node Version Manager (NVM) with latest LTS version
  - Package Managers: npm, yarn, pnpm, bun
  - Tools: npx, Supabase CLI
  - Development Tools: nodemon, pm2, typescript, eslint, prettier
- **PHP Ecosystem**:
  - PHP 8.x with common extensions
  - Composer
  - Laravel CLI
  - Symfony CLI
- **Golang**: Latest stable version
- **Docker & Containers**: 
  - Docker Engine 
  - Docker Compose
  - Docker Desktop (GUI)
- **Virtualization**:
  - VirtualBox

### IDEs & Code Editors
- **Visual Studio Code**: With popular extensions for development
- **Cursor Editor**: AI-powered editor

### Database Tools
- **CLI Clients**: SQLite, Redis, MariaDB, PostgreSQL
- **GUI Tools**:
  - DBeaver (universal database tool)
  - MySQL Workbench
  - MongoDB Compass

### API Development
- **API Testing Tools**:
  - Postman
  - Insomnia

### Other Utilities
- **Graphics & Media**: GIMP, Inkscape, VLC, OBS Studio
- **System Tools**: Timeshift, GParted, FileZilla

## Usage on Linux Mint

1. Clone this repository
2. Make the script executable: `chmod +x setup_dev_environment.sh`
3. Run the script: `./setup_dev_environment.sh`
4. You'll be prompted for your Git user name, email, and SSH key information
5. Log out and log back in for ZSH, Docker group, and other changes to take effect
6. Configure your ZSH theme with `p10k configure` for a personalized experience

## Testing with Docker (for Mac/Windows Users)

If you're on a Mac or Windows and want to test the script before using it on a Linux Mint machine:

1. Make sure Docker Desktop is installed and running
2. Run: `docker-compose up -d`
3. Connect to the container: `docker exec -it linuxmint-dev bash`
4. Inside the container, run: `./setup_dev_environment.sh`

## Customization

Feel free to modify the `setup_dev_environment.sh` script to add or remove packages based on your specific development needs. The script is modular, so you can comment out sections you don't need. 