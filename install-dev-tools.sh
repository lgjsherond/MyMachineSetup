#!/bin/bash

# Script for setting up development environment on macOS and Linux
# Author: Sheron Gerard Jeshuran
# Version: 1.2

# Function to print error messages and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Update package list and install prerequisites
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update || error_exit "Failed to update package list"
    sudo apt-get install -y curl git maven nodejs npm golang-go \
                            dbeaver-ce intellij-idea-community vlc \
                            firefox || error_exit "Failed to install packages on Linux"
    
    # Install Amazon Corretto 21
    sudo apt-get install -y wget
    wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - || error_exit "Failed to add Corretto key"
    sudo add-apt-repository 'deb https://apt.corretto.aws stable main' || error_exit "Failed to add Corretto repository"
    sudo apt-get update || error_exit "Failed to update package list"
    sudo apt-get install -y java-21-amazon-corretto-jdk || error_exit "Failed to install Amazon Corretto 21"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Install Homebrew if not installed
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error_exit "Failed to install Homebrew"
    fi

    brew update || error_exit "Failed to update Homebrew"

     # Install Amazon Corretto 21
    brew tap homebrew/cask-versions
    brew install --cask corretto || error_exit "Failed to install Amazon Corretto 21"

    # Install Visual Studio Code
    echo "Installing VS Code..."
    brew install --cask visual-studio-code || error_exit "Failed to install Visual Studio Code"

    # Install Brave Browser
    echo "Installing Brave browser..."
    brew install --cask brave-browser || error_exit "Failed to install Brave browser"
    
    brew install git maven node go \
                 dbeaver-community intellij-idea-ce vlc \
                 firefox k6 mitmproxy|| error_exit "Failed to install packages on macOS"
   
fi

# Configure the Testrail-Result-Integration
sourceFile="./wiley.7z"
destinationFolder="$HOME/.m2/repository/com"

# Ensure the TestRail destination folder exists
if [ ! -d "$destinationFolder" ]; then
    echo "Creating destination folder..."
    mkdir -p "$destinationFolder" || error_exit "Failed to create destination folder"
fi

# Copy the Test Rail results file to the destination folder
echo "Copying the file to destination folder..."
cp "$sourceFile" "$destinationFolder" || error_exit "Failed to copy the file"

# Extract the TestRail Results library file in the destination folder
echo "Extracting 7z file..."
7z x "$destinationFolder/$(basename $sourceFile)" -o"$destinationFolder" -y || error_exit "Failed to extract 7z file"

echo "Test Rail Configuration successfully."

# Set up environment variables
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export MAVEN_HOME=$(dirname $(dirname $(readlink -f $(which mvn))))
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

echo "JAVA_HOME set to $JAVA_HOME"
echo "MAVEN_HOME set to $MAVEN_HOME"

# Verify installations
echo "Verifying installations..."
java -version || error_exit "Java installation verification failed"
mvn -version || error_exit "Maven installation verification failed"
node -v || error_exit "Node.js installation verification failed"
npm -v || error_exit "NPM installation verification failed"
go version || error_exit "Go installation verification failed"

# Refresh environment variables
source ~/.bash_profile || error_exit "Failed to source .bash_profile"

# Install VS Code required extentions
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

mkdir -p "$HOME/.zfunc"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zfunc/pure"

echo "Setup completed successfully. Please restart your terminal to apply changes."

# List installed applications
echo "Listing installed applications..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    dpkg --get-selections || error_exit "Failed to list installed packages on Linux"
    snap list || error_exit "Failed to list installed Snap packages"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew list || error_exit "Failed to list Homebrew packages"
    ls /Applications || error_exit "Failed to list applications in /Applications"
fi

echo "Installed applications listed successfully."
