# ==============================================================
# Windows Setup Script
# ==============================================================
# This script installs various software packages using Chocolatey.
#
# Installation Information:
# - Chocolatey (https://chocolatey.org)
# - k6 (https://k6.io)
# - Node.js (https://nodejs.org)
# - Fiddler Classic (https://www.telerik.com/fiddler)
# - Brave (https://brave.com)
# - Firefox (https://www.mozilla.org/firefox)
# - Visual Studio Code (https://code.visualstudio.com)
# - Go Programming (https://golang.org)
# - DBeaver Community (https://dbeaver.io)
# - IntelliJ IDEA Community Edition (https://www.jetbrains.com/idea)
#
# Make sure to run this script with administrator privileges.
# ==============================================================

# Install Chocolatey (if not already installed)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install k6
choco install k6 -y

# Install Node.js
choco install nodejs -y

# Install Fiddler Classic
choco install fiddler -y

# Install Brave
choco install brave -y

# Install Firefox
choco install firefox -y

# Install Visual Studio Code
choco install vscode -y

# Install Go Programming
choco install golang -y

# Install DBeaver Community
choco install dbeaver -y

# Install IntelliJ IDEA Community Edition
choco install intellijidea-community -y

# Refresh environment variables
refreshenv
