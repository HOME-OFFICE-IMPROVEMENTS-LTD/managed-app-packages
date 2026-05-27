using './main.bicep'

param adminUsername = 'msalsouri'
param sshPublicKey = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPilBpgbwCPEvNmWSSdrXKA6Mm8gddBe3lTQGgELLmo'
param vmName = 'dokku-test-vm'
param vmSize = 'Standard_B2ms'
param dokkuVersion = '0.35.15'
param securityType = 'TrustedLaunch'
