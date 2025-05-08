#!/bin/bash

# Development Environment Setup Script for Linux Mint
# Supports: PHP, Node.js, Golang, Docker, Docker Compose

echo "Starting development environment setup..."

# Update system packages
echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install essential build tools and dependencies
echo "Installing essential build tools and utilities..."
sudo apt install -y build-essential curl wget git vim unzip apt-transport-https \
    ca-certificates software-properties-common gnupg lsb-release zsh

# Git configuration
echo "Setting up Git configuration..."
read -p "Enter your Git user name: " GIT_USER_NAME
read -p "Enter your Git email address: " GIT_USER_EMAIL
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main
git config --global core.editor vim
git config --global pull.rebase false
echo "Git configured successfully!"

# Generate SSH Key
echo "Setting up SSH key..."
read -p "Enter your email for SSH key (default: $GIT_USER_EMAIL): " SSH_EMAIL
SSH_EMAIL=${SSH_EMAIL:-$GIT_USER_EMAIL}
ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f ~/.ssh/id_ed25519 -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "SSH key generated. Your public key is:"
cat ~/.ssh/id_ed25519.pub
echo "Don't forget to add this key to your GitHub/GitLab account."

# Install and configure ZSH with Oh My Zsh and plugins
echo "Installing and configuring ZSH with Oh My Zsh and plugins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# Update .zshrc with plugins
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc

# Change default shell to ZSH if not already ZSH
if [[ "$SHELL" != "/bin/zsh" ]]; then
  echo "Changing default shell to ZSH..."
  chsh -s $(which zsh)
fi

# Install Warp Terminal
echo "Installing Warp Terminal..."
wget https://app.warp.dev/download?package=deb -O warp-terminal.deb
sudo dpkg -i warp-terminal.deb
sudo apt --fix-broken install -y
rm warp-terminal.deb
echo "Warp Terminal installed successfully!"

# Install NVM (Node Version Manager)
echo "Installing NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Setup NVM in shell profiles
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.bashrc

echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc

# Install the latest LTS version of Node.js via NVM (we'll need to source nvm first)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

# Install additional Node.js package managers and tools
echo "Installing additional Node.js package managers and tools..."
# Install yarn
npm install -g yarn
# Install pnpm
npm install -g pnpm
# Install bun
curl -fsSL https://bun.sh/install | bash
# npx is included with npm, but make sure it's properly linked
npm install -g npx
# Install Supabase CLI
npm install -g @supabase/cli

# Setup path for bun
echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc
echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.zshrc
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.zshrc

# Install PHP and common extensions
echo "Installing PHP and extensions..."
sudo apt install -y php php-cli php-fpm php-json php-common php-mysql php-zip \
    php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-intl

# Install Composer (PHP package manager)
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel CLI
echo "Installing Laravel CLI..."
composer global require laravel/installer
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.zshrc

# Install Symfony CLI
echo "Installing Symfony CLI..."
curl -sS https://get.symfony.com/cli/installer | bash
echo 'export PATH="$HOME/.symfony5/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.symfony5/bin:$PATH"' >> ~/.zshrc

# Install Golang
echo "Installing Golang..."
GO_VERSION="1.21.0"
wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
rm go$GO_VERSION.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.zshrc

# Install Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="v2.20.2"
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add current user to docker group to avoid using sudo with docker
echo "Adding user to docker group..."
sudo usermod -aG docker $USER

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

# Install Cursor Editor
echo "Installing Cursor Editor..."
# Download the latest .deb package
wget -O cursor.deb https://cursor.sh/api/unix-deb-package
# Install the package
sudo dpkg -i cursor.deb
# Install dependencies that might be missing
sudo apt-get install -f -y
# Clean up
rm cursor.deb

# Install additional helpful development tools
echo "Installing additional development tools..."
sudo apt install -y sqlite3 redis-tools mariadb-client postgresql-client

# Cleanup
echo "Cleaning up..."
sudo apt autoremove -y
sudo apt clean

echo "Development environment setup complete!"
echo "Please log out and log back in for Docker group changes to take effect."
echo "If you want to start using ZSH now, run: zsh"
echo "Alternatively, for Docker group changes only, you can run: newgrp docker" 