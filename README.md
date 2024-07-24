# My Mac Setup

This repository provides a script to automate the installation of essential tools for your Mac development environment.

## Prerequisites
* macOS system
* Internet access
* Ability to enter your password when prompted for sudo privileges
---
## Installation

Clone the Repository:
```
Bash

git clone https://github.com/lgjsherond/MyMacSetup.git
```
Use code with caution.

Navigate to the Directory:
```
Bash

cd MyMacSetup
```
Use code with caution.

Run the Script:

Important: This script requires sudo privileges. You may be prompted for your password during the installation process.
```
Bash

sudo ./install-mac-tools.sh
```
**Use code with caution**

---
## What's Included

The script installs the following tools:

* Brave Browser: A secure and privacy-focused web browser.
* Homebrew: A popular package manager for macOS that simplifies software installation.
* k6: A load testing tool for performance evaluation.
* mitmproxy: An interactive HTTP proxy for debugging and manipulating web traffic.
* MySQL Workbench : Is a unified visual database design tool developed by Oracle Corporation
* Visual Studio Code (code): A versatile and powerful code editor.
* Oh My ZSH (Optional): A framework for customizing your ZSH terminal experience. (Note: You may need to further configure Oh My ZSH after installation.)

## Additional Notes

After installing Oh My ZSH, you might want to customize your settings in the ~/.zshrc file. Refer to the Oh My ZSH documentation for instructions: https://ohmyz.sh/
Consider restarting your terminal for the changes to take full effect.
Contributing

Feel free to fork this repository and make changes to customize the script for your specific needs. If you have improvements or additional tools you'd like to include, please consider creating a pull request to contribute to the project.

Happy Coding!
