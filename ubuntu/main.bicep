@description('Name of the virtual machine.')
param vmName string

@description('Username for the virtual machine.')
param adminUsername string

@description('Type of authentication to use on the virtual machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'sshPublicKey'

@description('SSH public key or password for the virtual machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string

@description('Ubuntu LTS version to deploy.')
@allowed([
  'Ubuntu-2204'
  'Ubuntu-2404'
  'Ubuntu-2604'
])
param ubuntuVersion string = 'Ubuntu-2404'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2s_v3'

@description('Security type of the virtual machine.')
@allowed([
  'Standard'
  'TrustedLaunch'
])
param securityType string = 'TrustedLaunch'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the virtual network.')
param virtualNetworkName string = '${vmName}-vnet'

@description('Name of the subnet.')
param subnetName string = 'default'

@description('Name of the network security group.')
param networkSecurityGroupName string = '${vmName}-nsg'

@description('Tags to apply to all resources.')
param tagsByResource object = {}

var imageReferences = {
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2404': {
    publisher: 'Canonical'
    offer: 'ubuntu-24_04-lts'
    sku: 'server'
    version: 'latest'
  }
  'Ubuntu-2604': {
    publisher: 'Canonical'
    offer: 'ubuntu-26_04-lts'
    sku: 'server'
    version: 'latest'
  }
}

var publicIPAddressName = '${vmName}-pip'
var networkInterfaceName = '${vmName}-nic'
var osDiskType = 'Premium_LRS'
var subnetAddressPrefix = '10.1.0.0/24'
var addressPrefix = '10.1.0.0/16'
var dnsLabelPrefix = '${toLower(vmName)}-${uniqueString(resourceGroup().id)}'

var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}

var securityProfileJson = {
  uefiSettings: {
    secureBootEnabled: true
    vTpmEnabled: true
  }
  securityType: securityType
}

var extensionName = 'GuestAttestation'
var extensionPublisher = 'Microsoft.Azure.Security.LinuxAttestation'
var extensionVersion = '1.0'
var maaTenantName = 'GuestAttestation'
var maaEndpoint = substring('emptystring', 0, 0)

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-10-01' = {
  name: networkSecurityGroupName
  location: location
  tags: tagsByResource[?'Microsoft.Network/networkSecurityGroups'] ?? {}
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: virtualNetworkName
  location: location
  tags: tagsByResource[?'Microsoft.Network/virtualNetworks'] ?? {}
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2024-10-01' = {
  name: publicIPAddressName
  location: location
  tags: tagsByResource[?'Microsoft.Network/publicIPAddresses'] ?? {}
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 4
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2024-10-01' = {
  name: networkInterfaceName
  location: location
  tags: tagsByResource[?'Microsoft.Network/networkInterfaces'] ?? {}
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: vmName
  location: location
  tags: tagsByResource[?'Microsoft.Compute/virtualMachines'] ?? {}
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: imageReferences[ubuntuVersion]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: (authenticationType == 'password') ? null : linuxConfiguration
    }
    securityProfile: (securityType == 'TrustedLaunch') ? securityProfileJson : null
  }
}

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2024-11-01' = if (securityType == 'TrustedLaunch' && securityProfileJson.uefiSettings.secureBootEnabled && securityProfileJson.uefiSettings.vTpmEnabled) {
  parent: vm
  name: extensionName
  location: location
  properties: {
    publisher: extensionPublisher
    type: extensionName
    typeHandlerVersion: extensionVersion
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
    settings: {
      AttestationConfig: {
        MaaSettings: {
          maaEndpoint: maaEndpoint
          maaTenantName: maaTenantName
        }
      }
    }
  }
}

output adminUsername string = adminUsername
output hostname string = publicIPAddress.properties.dnsSettings.fqdn
output sshCommand string = 'ssh ${adminUsername}@${publicIPAddress.properties.dnsSettings.fqdn}'
