#!/bin/bash

# Modificando o script original para funcionar em ambiente de teste
echo "Preparando o ambiente de teste..."

# Criar uma versão modificada do script para teste
cat > test_setup.sh << 'EOTESTSETUP'
#!/bin/bash

# Atualizar pacotes do sistema
echo "Atualizando pacotes do sistema..."
sudo apt update

# Instalar ferramentas essenciais
echo "Instalando ferramentas essenciais..."
sudo apt install -y build-essential curl wget git vim unzip zsh

# Configuração do Git
echo "Configurando Git..."
GIT_USER_NAME="Test User"
GIT_USER_EMAIL="test@example.com"
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main
git config --global core.editor vim
git config --global pull.rebase false
echo "Git configurado com sucesso!"

# Gerar chave SSH
echo "Gerando chave SSH..."
SSH_EMAIL="test@example.com"
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f ~/.ssh/id_ed25519 -N ""
echo "Chave SSH gerada com sucesso!"

# Instalar Oh My Zsh
echo "Instalando Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Instalar plugins ZSH
echo "Instalando plugins ZSH..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Criar arquivo .zshrc básico
echo "Criando arquivo .zshrc..."
cat > ~/.zshrc << 'EOZSHRC'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
EOZSHRC

# Testar instalação de fontes de programação
echo "Testando instalação de fontes..."
mkdir -p ~/.local/share/fonts
wget -q https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -O firacode.zip
unzip -q firacode.zip -d firacode
cp firacode/ttf/*.ttf ~/.local/share/fonts/
rm -rf firacode firacode.zip

echo "Teste básico concluído com sucesso!"
EOTESTSETUP

chmod +x test_setup.sh
./test_setup.sh
