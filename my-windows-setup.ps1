# ==============================================================
# Windows Setup Script
# ==============================================================
# This script installs various software packages using Chocolatey.
#
# Installation Information:
# - Chocolatey (https://chocolatey.org)
# - GIT
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
# ==============================================================
# Windows Setup Script (Up-to-date: 2025-05)
# ==============================================================

# ==============================================================
# Windows Setup Script (Up-to-date: 2025-05, with error handling)
# ==============================================================

# Abort script on any error
$ErrorActionPreference = 'Stop'

# Ensure running as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as an Administrator!"
    Exit 1
}

# Error handler
function Abort-OnError {
    param([string]$message)
    Write-Error $message
    Exit 1
}

try {
    # Check and install/update latest PowerShell
    $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
    $latestVersion = $latestRelease.tag_name
    $msiUrl = $latestRelease.assets | Where-Object { $_.name -like "*win-x64.msi" } | Select-Object -ExpandProperty browser_download_url

    if ($PSVersionTable.PSVersion -lt [version]$latestVersion) {
        Write-Output "Updating PowerShell to version $latestVersion ..."
        Invoke-WebRequest -Uri $msiUrl -OutFile "$env:TEMP\PowerShell-latest.msi"
        Start-Process msiexec.exe -ArgumentList "/i $env:TEMP\PowerShell-latest.msi /quiet" -NoNewWindow -Wait
        Remove-Item "$env:TEMP\PowerShell-latest.msi"
        Write-Output "PowerShell updated. Please restart your session before rerunning this script."
        Exit 0
    }

    # Install Chocolatey if not present
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Output "Chocolatey not found. Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        # Add choco to PATH for current session
        $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
    }

    # Wait for choco command to be available
    $maxTries = 10
    $try = 0
    while (-not (Get-Command choco -ErrorAction SilentlyContinue) -and $try -lt $maxTries) {
        Start-Sleep -Seconds 2
        $try++
    }
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Abort-OnError "Chocolatey installation failed or PATH not set. Please restart PowerShell and rerun this script."
    }

    # Helper function to install packages via choco and abort on failure
    function Install-ChocoPackage {
        param (
            [string]$package,
            [string]$extraArgs = ""
        )
        Write-Output "Installing $package ..."
        choco install $package -y $extraArgs
        if ($LASTEXITCODE -ne 0) {
            Abort-OnError "Failed to install $package. Aborting."
        } else {
            Write-Output "$package installed successfully."
        }
    }

    # Software Installations
    Install-ChocoPackage git
    Install-ChocoPackage openjdk
    Install-ChocoPackage maven
    Install-ChocoPackage k6
    Install-ChocoPackage 7zip
    Install-ChocoPackage nodejs
    Install-ChocoPackage fiddler
    Install-ChocoPackage mitmproxy
    Install-ChocoPackage brave
    Install-ChocoPackage firefox
    Install-ChocoPackage golang
    Install-ChocoPackage dbeaver
    Install-ChocoPackage vscode
    Install-ChocoPackage intellijidea-community
    Install-ChocoPackage zap
    Install-ChocoPackage vlc
    Install-ChocoPackage oh-my-posh

    # Add 7-Zip to PATH
    $sevenZipPath = "C:\Program Files\7-Zip"
    if (Test-Path $sevenZipPath) {
        $env:Path += ";$sevenZipPath"
        [System.Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "7-Zip added to PATH."
    }

    # Set JAVA_HOME and MAVEN_HOME environment variables
    $mavenHome = (Get-Command mvn).Path | Split-Path -Parent -Parent
    $jdkPath = (Get-Command java).Path | Split-Path -Parent -Parent

    Write-Output "Setting JAVA_HOME and MAVEN_HOME..."
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, [System.EnvironmentVariableTarget]::Machine)
    [System.Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenHome, [System.EnvironmentVariableTarget]::Machine)
    $env:Path += ";$mavenHome\bin"
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)

    # Verify installations
    Write-Output "Verifying Maven and Java installations:"
    try { mvn -version } catch { Abort-OnError "Maven verification failed. Aborting." }
    try { java -version } catch { Abort-OnError "Java verification failed. Aborting." }

    # Install VSCode Extensions
    $codeCmd = "code"
    if (Get-Command $codeCmd -ErrorAction SilentlyContinue) {
        $extensions = @(
            "vscjava.vscode-java-pack",
            "redhat.java",
            "vscjava.vscode-maven",
            "vscjava.vscode-java-test",
            "k6.k6",
            "dbaeumer.vscode-eslint",
            "ms-vscode.vscode-typescript-next",
            "github.vscode-github-actions",
            "github.copilot",
            "github.copilot-chat",
            "ms-vscode-remote.remote-wsl",
            "ms-azuretools.vscode-docker"
        )
        foreach ($ext in $extensions) {
            Write-Output "Installing VSCode extension: $ext"
            code --install-extension $ext
            if ($LASTEXITCODE -ne 0) {
                Abort-OnError "Failed to install VSCode extension $ext. Aborting."
            }
        }
        Write-Output "VSCode Extensions installation completed."
    } else {
        Write-Warning "VSCode 'code' command not found in PATH. Skipping VSCode extensions installation."
    }

    # Oh My Posh font install (requires user interaction)
    try {
        oh-my-posh font install meslo
        Write-Output "Oh My Posh Meslo font installed."
    } catch {
        Write-Warning "Could not install Oh My Posh font. Please install manually if needed."
    }

    # TestRail configuration (wiley.7z extraction)
    $sourceFile = ".\wiley.7z"  
    $destinationFolder = "$env:USERPROFILE\.m2\repository\com"

    if (-not (Test-Path -Path $destinationFolder)) {
        Write-Output "Creating destination folder..."
        New-Item -ItemType Directory -Path $destinationFolder -Force
    }
    Write-Output "Copying wiley.7z to destination folder..."
    Copy-Item -Path $sourceFile -Destination $destinationFolder
    Write-Output "Extracting wiley.7z..."
    7z x "$destinationFolder\wiley.7z" -o"$destinationFolder" -y

    # Refresh environment variables
    if (Get-Command refreshenv -ErrorAction SilentlyContinue) {
        refreshenv
    } else {
        Write-Output "Please restart your terminal or run 'refreshenv' to reload environment variables."
    }

    Write-Output "Windows machine setup completed successfully."

} catch {
    Abort-OnError "An error occurred: $_"
}
