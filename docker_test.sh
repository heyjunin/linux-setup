#!/bin/bash

echo "=== Iniciando o teste do script de setup com Docker ==="

# Construir a imagem Docker
echo "Construindo a imagem Docker..."
docker-compose build

# Iniciar o container em segundo plano
echo "Iniciando o container..."
docker-compose up -d

# Criar um script de teste que será executado dentro do container
cat > test_inside_container.sh << 'EOL'
#!/bin/bash

# Modificando o script original para funcionar em ambiente de teste
echo "Preparando o ambiente de teste..."
sed -i 's/read -p "Enter your Git user name: " GIT_USER_NAME/GIT_USER_NAME="Test User"/g' setup_dev_environment.sh
sed -i 's/read -p "Enter your Git email address: " GIT_USER_EMAIL/GIT_USER_EMAIL="test@example.com"/g' setup_dev_environment.sh
sed -i 's/read -p "Enter your email for SSH key (default: $GIT_USER_EMAIL): " SSH_EMAIL/SSH_EMAIL="$GIT_USER_EMAIL"/g' setup_dev_environment.sh

# Comentar comandos que requerem interatividade ou serviços que não funcionam em Docker
sed -i 's/sudo ufw enable/#sudo ufw enable/g' setup_dev_environment.sh
sed -i 's/sudo systemctl enable fail2ban/#sudo systemctl enable fail2ban/g' setup_dev_environment.sh
sed -i 's/sudo systemctl start fail2ban/#sudo systemctl start fail2ban/g' setup_dev_environment.sh

# Reduzindo o escopo do teste para essenciais
echo "Modificando o script para teste em Docker..."
sed -i 's/sudo apt upgrade -y/sudo apt upgrade -y --no-install-recommends/g' setup_dev_environment.sh
sed -i 's/chsh -s $(which zsh)/echo "Mudança de shell seria feita aqui"/g' setup_dev_environment.sh

# Executar uma versão reduzida do script
echo "=== Executando um teste reduzido do script de setup ==="
echo "Isso testará apenas algumas partes para verificar a sintaxe e o fluxo básico."

# Criando um script temporário com apenas parte das instalações para teste
cat > test_setup.sh << 'EOTESTSETUP'
#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update

# Install essential build tools and dependencies
echo "Installing essential build tools and utilities..."
sudo apt install -y build-essential curl wget git vim unzip zsh

# Git configuration
echo "Setting up Git configuration..."
GIT_USER_NAME="Test User"
GIT_USER_EMAIL="test@example.com"
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main
git config --global core.editor vim
git config --global pull.rebase false
echo "Git configured successfully!"

# Generate SSH Key
echo "Setting up SSH key..."
SSH_EMAIL="test@example.com"
ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f ~/.ssh/id_ed25519 -N ""
echo "SSH key generated successfully!"

# Install and configure ZSH with Oh My Zsh and plugins
echo "Installing and configuring ZSH with Oh My Zsh and plugins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Create basic .zshrc
cat > ~/.zshrc << 'EOL'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
EOL

# Test programming fonts installation
echo "Testing font installation..."
mkdir -p ~/.local/share/fonts
wget -q https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -O firacode.zip
unzip -q firacode.zip -d firacode
cp firacode/ttf/*.ttf ~/.local/share/fonts/
rm -rf firacode firacode.zip

echo "Basic test setup completed successfully!"
EOTESTSETUP

chmod +x test_setup.sh
./test_setup.sh

echo "=== Teste concluído! ==="
EOL

chmod +x test_inside_container.sh

# Copiar o script de teste para o container
echo "Copiando o script de teste para o container..."
docker cp test_inside_container.sh linuxmint-dev:/home/developer/

# Executar o script de teste dentro do container
echo "Executando o teste dentro do container..."
docker exec -it linuxmint-dev bash -c "cd /home/developer && ./test_inside_container.sh"

# Verificar o resultado
echo "Verificando resultado do teste..."
docker exec -it linuxmint-dev bash -c "ls -la /home/developer/.ssh/ && cat /home/developer/.zshrc && git config --global --list"

# Limpar
echo "Limpando ambiente de teste..."
#docker-compose down
echo "Não derrubaremos o container ainda para permitir inspeção manual."
echo "Para desligar o container: docker-compose down"

echo "=== Teste concluído! ==="
echo "Para se conectar ao container e inspecionar manualmente: docker exec -it linuxmint-dev bash" 