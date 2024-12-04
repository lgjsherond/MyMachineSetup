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
