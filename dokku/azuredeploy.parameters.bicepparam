using './main.bicep'

param adminUsername = 'msalsouri'
param sshPublicKey = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPilBpgbwCPEvNmWSSdrXKA6Mm8gddBe3lTQGgELLmo'
param vmName = 'dokku-test-vm'
param vmSize = 'Standard_B2ms'
param dokkuVersion = '0.35.15'
param securityType = 'TrustedLaunch'
// Required for local/VS Code deploy — scripts fetched from GitHub
// Partner Center sets this automatically from the hosted zip URI
param _artifactsLocation = 'https://raw.githubusercontent.com/HOME-OFFICE-IMPROVEMENTS-LTD/managed-app-packages/main/dokku/'
