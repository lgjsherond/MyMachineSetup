#!/bin/bash

# Script for setting up development environment on macOS and Linux

# Update package list and install prerequisites
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update
    sudo apt-get install -y curl git openjdk-11-jdk maven nodejs npm golang-go \
                            dbeaver-ce intellij-idea-community vlc \
                            firefox
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Install Homebrew if not installed
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew update
    brew install git openjdk@11 maven node go \
                 dbeaver-community intellij-idea-ce vlc \
                 firefox
fi

# Install GIT
brew install git
git --version

#install GO
brew install go
go version

# Set up environment variables
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
export MAVEN_HOME=$(dirname $(dirname $(readlink -f $(which mvn))))
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

echo "JAVA_HOME set to $JAVA_HOME"
echo "MAVEN_HOME set to $MAVEN_HOME"

# Verify installations
echo "Verifying installations..."
java -version
mvn -version
node -v
npm -v
go version

# Install Visual Studio Code and extensions
echo "Installing Visual Studio Code and extensions"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo snap install --classic code
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install --cask visual-studio-code
fi

code --install-extension vscjava.vscode-java-pack
code --install-extension redhat.java
code --install-extension vscjava.vscode-maven
code --install-extension vscjava.vscode-java-test
code --install-extension k6.k6
code --install-extension dbaeumer.vscode-eslint
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension github.vscode-github-actions
code --install-extension github.copilot
code --install-extension github.copilot-chat
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-azuretools.vscode-docker

echo "VS Code and extensions installed successfully."

# Install Brave browser using Homebrew
echo "Installing Brave browser..."
brew install cask
brew install brave

# Install k6 load testing tool using Homebrew
echo "Installing k6 load testing tool..."
brew install k6

# Install mitmproxy (interactive HTTP proxy) using Homebrew
echo "Installing mitmproxy..."
brew install mitmproxy

# Install Oh My ZSH (customization framework)
if [ ! -d ~/.oh-my-zsh ]; then
  echo "Installing Oh My ZSH..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Clone Oh My ZSH themes repository (optional)
# You can choose a theme you like from https://github.com/ohmyzsh/ohmyzsh-themes
git clone https://github.com/ohmyzsh/ohmyzsh-themes ~/.oh-my-zsh/themes

# Set up your preferred theme in your ~/.zshrc file
# Refer to the Oh My ZSH documentation for instructions: https://ohmyzsh.com/

# Source the updated .zshrc file to apply changes
source ~/.zshrc

echo "Setup completed successfully. Please restart your terminal to apply changes."
