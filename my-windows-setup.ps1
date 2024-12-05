# ==============================================================
# Windows Setup Script
# ==============================================================
# This script installs various software packages using Chocolatey.
#
# Installation Information:
# - Chocolatey (https://chocolatey.org)
# - k6 (https://k6.io)
# - Node.js (https://nodejs.org)
# - Maven
# - Open JDK
# - Configure the Maven and JDK
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

# Insall JDK
choco install openjdk -y
Write-Output "JDK installation completed successfully."

# Install Maven
choco install maven -y
Write-Output "Maven installation completed successfully."


# Set environment variables
$mavenHome = (Get-Command mvn).Path | Split-Path -Parent -Parent
$jdkPath = (Get-Command java).Path | Split-Path -Parent -Parent

Write-Output "Setting environment variables..."
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenHome, [System.EnvironmentVariableTarget]::Machine)
$env:Path += ";$mavenHome\bin"
[System.Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
$env:JDKPath += ";$jdkPath\bin"
[System.Environment]::SetEnvironmentVariable("Path", $env:JDKPath, [System.EnvironmentVariableTarget]::Machine)

# Verify installation
Write-Output "Verifying Maven installation..."
mvn -version
java -version
Write-Output "JDK & Maven installation and configuration completed successfully."


# Install k6
choco install k6 -y
Write-Output "K6 installation completed successfully."

# 7 Zip
choco install 7zip -y
# Get the 7-Zip installation path
$sevenZipPath = "C:\Program Files\7-Zip"
# Add 7-Zip to the PATH environment variable
$env:Path += ";$sevenZipPath"
[System.Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
Write-Output "7Zip installation completed successfully."

# Install Node.js
choco install nodejs -y
Write-Output "Node JS installation completed successfully."

# Install Fiddler Classic
choco install fiddler -y
Write-Output "Fiddler installation completed successfully."

# Install Brave
choco install brave -y
Write-Output "Brave installation completed successfully."

# Install Firefox
choco install firefox -y
Write-Output "Firefox installation completed successfully."

# Install Go Programming
choco install golang -y
Write-Output "Go Programming Language installation completed successfully."

# Install DBeaver Community
choco install dbeaver -y
Write-Output "DBeaver installation completed successfully."

# Install Visual Studio Code
choco install vscode -y
Write-Output "VS Code installation completed successfully."

# Install IntelliJ IDEA Community Edition
choco install intellijidea-community -y
Write-Output "IntelliJ Community Edition installation completed successfully."

# Install VLCn
choco install vlc -y
Write-Output "VLC installation completed successfully."

# Install Oh My Posh
choco install oh-my-posh -y
oh-my-posh font install meslo
Write-Output "Oh my Posh for Powershell installation completed successfully."

# Configure the Testrail-Result-Integration
$sourceFile = ".\wiley.7z"  
$destinationFolder = "$env:USERPROFILE\.m2\repository\com"

# Ensure the destination folder exists
if (-not (Test-Path -Path $destinationFolder)) {
    Write-Output "Creating destination folder..."
    New-Item -ItemType Directory -Path $destinationFolder -Force
}

# Copy the Test Rail results file to the destination folder
Write-Output "Copying the file to destination folder..."
Copy-Item -Path $sourceFile -Destination $destinationFolder

# Extract the TestRail Results linrary file in the destination folder
Write-Output "Extracting 7z file..."
7z x "$destinationFolder\$sourceFile" -o"$destinationFolder" -y

Write-Output "Test Rail Configuration successfully."

# Refresh environment variables
refreshenv
