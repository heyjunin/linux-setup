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
    ca-certificates software-properties-common gnupg lsb-release zsh \
    htop glances net-tools iotop ncdu tldr bat fd-find ripgrep jq fzf neofetch \
    ufw fail2ban

# Setup Basic Firewall
echo "Setting up basic firewall..."
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw status

# Setup fail2ban for SSH protection
echo "Configuring fail2ban for SSH protection..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Git configuration
echo "Setting up Git configuration..."
read -p "Enter your Git user name: " GIT_USER_NAME
read -p "Enter your Git email address: " GIT_USER_EMAIL
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main
git config --global core.editor vim
git config --global pull.rebase false
git config --global credential.helper store
git config --global color.ui auto
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

# Create backup of SSH keys
mkdir -p ~/backup
cp -r ~/.ssh ~/backup/ssh_backup_$(date +%Y%m%d)
chmod 700 ~/backup/ssh_backup_$(date +%Y%m%d)
echo "SSH keys backed up to ~/backup/ssh_backup_$(date +%Y%m%d)"

# Install and configure ZSH with Oh My Zsh and plugins
echo "Installing and configuring ZSH with Oh My Zsh and plugins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/k
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/wfxr/forgit.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/forgit
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Backup original .zshrc and create a new one
cp ~/.zshrc ~/.zshrc.bak

# Create new optimized .zshrc
cat > ~/.zshrc << 'EOL'
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme to powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set plugins
plugins=(
  git
  docker
  docker-compose
  npm
  composer
  golang
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  zsh-autocomplete
  k
  fzf-tab
  forgit
  zsh-vi-mode
  z
  history
  sudo
  web-search
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# Aliases
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'
alias h='history'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias d='docker'
alias dc='docker-compose'
alias k='kubectl'
alias tf='terraform'
alias python='python3'
alias cat='bat --style=plain'
alias find='fd'
alias grep='rg'
alias top='htop'

# Load FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

# Download and install p10k configuration
curl -fsSL https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k-rainbow.zsh > ~/.p10k.zsh

# Install Programming Fonts
echo "Installing programming fonts..."
mkdir -p ~/.local/share/fonts

# Download and install Fira Code
wget -q https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -O firacode.zip
unzip -q firacode.zip -d firacode
cp firacode/ttf/*.ttf ~/.local/share/fonts/
rm -rf firacode firacode.zip

# Download and install Jetbrains Mono
wget -q https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -O jetbrains.zip
unzip -q jetbrains.zip -d jetbrains
cp jetbrains/fonts/ttf/*.ttf ~/.local/share/fonts/
rm -rf jetbrains jetbrains.zip

# Download and install Cascadia Code
wget -q https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip -O cascadia.zip
unzip -q cascadia.zip -d cascadia
cp cascadia/ttf/*.ttf ~/.local/share/fonts/
rm -rf cascadia cascadia.zip

# Refresh font cache
fc-cache -f -v

# Install Warp Terminal
echo "Installing Warp Terminal..."
wget https://app.warp.dev/download?package=deb -O warp-terminal.deb
sudo dpkg -i warp-terminal.deb
sudo apt --fix-broken install -y
rm warp-terminal.deb
echo "Warp Terminal installed successfully!"

# Install Kitty Terminal (alternative)
echo "Installing Kitty terminal..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
mkdir -p ~/.config/kitty
cat > ~/.config/kitty/kitty.conf << 'EOL'
font_family      JetBrains Mono
bold_font        JetBrains Mono Bold
italic_font      JetBrains Mono Italic
bold_italic_font JetBrains Mono Bold Italic
font_size 13.0
cursor_shape beam
window_padding_width 10
background_opacity 0.95
foreground #f8f8f2
background #282a36
enable_audio_bell no
EOL

# Create desktop shortcut for Kitty
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/kitty.desktop << 'EOL'
[Desktop Entry]
Version=1.0
Type=Application
Name=Kitty
GenericName=Terminal Emulator
Comment=Fast, feature-rich, GPU based terminal
Exec=/home/$USER/.local/kitty.app/bin/kitty
Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
Categories=System;TerminalEmulator;
Terminal=false
EOL

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
# Install other useful npm tools
npm install -g tldr http-server json-server nodemon pm2 typescript ts-node eslint prettier

# Setup path for bun
echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc
echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.zshrc
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.zshrc

# Install PHP and common extensions
echo "Installing PHP and extensions..."
sudo apt install -y php php-cli php-fpm php-json php-common php-mysql php-zip \
    php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-intl \
    php-sqlite3 php-xdebug php-redis php-mongodb

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

# Install Docker Desktop
echo "Installing Docker Desktop..."
DOCKER_DESKTOP_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-4.25.0-amd64.deb"
wget -O docker-desktop.deb $DOCKER_DESKTOP_URL
sudo apt install -y ./docker-desktop.deb
rm docker-desktop.deb

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

# Install popular VSCode extensions
echo "Installing VSCode extensions..."
code --install-extension ms-vscode.cpptools
code --install-extension ms-python.python
code --install-extension golang.go
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-azuretools.vscode-docker
code --install-extension ritwickdey.liveserver
code --install-extension ms-vscode.cmake-tools
code --install-extension redhat.vscode-yaml
code --install-extension hediet.vscode-drawio
code --install-extension mhutchie.git-graph
code --install-extension johnpapa.vscode-peacock
code --install-extension oderwat.indent-rainbow
code --install-extension PKief.material-icon-theme
code --install-extension dracula-theme.theme-dracula
code --install-extension ms-mssql.mssql
code --install-extension humao.rest-client
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension GitHub.github-vscode-theme

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

# Install Database tools
echo "Installing database tools..."
# Install DBeaver
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt update
sudo apt install -y dbeaver-ce

# Install MySQL Workbench
sudo apt install -y mysql-workbench

# Install MongoDB Compass
wget -O mongodb-compass.deb https://downloads.mongodb.com/compass/mongodb-compass_1.39.0_amd64.deb
sudo dpkg -i mongodb-compass.deb
sudo apt-get install -f -y
rm mongodb-compass.deb

# Install API development tools
echo "Installing API development tools..."
# Install Postman
wget -O postman.tar.gz "https://dl.pstmn.io/download/latest/linux64"
sudo tar -xzf postman.tar.gz -C /opt
sudo ln -s /opt/Postman/Postman /usr/bin/postman
rm postman.tar.gz

# Create desktop shortcut for Postman
cat > ~/.local/share/applications/postman.desktop << 'EOL'
[Desktop Entry]
Name=Postman
GenericName=API Client
X-GNOME-FullName=Postman API Client
Comment=Make and view REST API calls and responses
Keywords=api;
Exec=/opt/Postman/Postman
Terminal=false
Type=Application
Icon=/opt/Postman/app/resources/app/assets/icon.png
Categories=Development;Network;
StartupWMClass=Postman
StartupNotify=true
EOL

# Install Insomnia
echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" | sudo tee /etc/apt/sources.list.d/insomnia.list
sudo apt update
sudo apt install -y insomnia

# Install VirtualBox
echo "Installing VirtualBox..."
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install -y virtualbox-7.0

# Install additional helpful development tools
echo "Installing additional development tools..."
sudo apt install -y sqlite3 redis-tools mariadb-client postgresql-client \
    filezilla gimp inkscape vlc obs-studio timeshift gparted

# Cleanup
echo "Cleaning up..."
sudo apt autoremove -y
sudo apt clean

echo "Development environment setup complete!"
echo "Please log out and log back in for Docker group changes to take effect."
echo "To configure your ZSH theme, run: p10k configure"
echo "If you want to start using ZSH now, run: zsh"
echo "Alternatively, for Docker group changes only, you can run: newgrp docker" 