#!/bin/bash

# Update system
echo "Updating system..."
sudo softwareupdate -l

# Install Homebrew (package manager)
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

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

# Install Visual Studio Code (code editor) using Homebrew
echo "Installing Visual Studio Code..."
brew install code

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

echo "Installation complete!"
