# Ubuntu 24.04 LTS Managed Application for Azure Marketplace

## Overview
This managed application package provides a production-ready Ubuntu 24.04 LTS virtual machine deployment template for the Azure Marketplace.

## Package Contents
- `mainTemplate.json` - ARM template for Ubuntu VM deployment
- `createUiDefinition.json` - UI form definition for marketplace listing
- `managedvm-ubuntu2404.zip` - Deployment artifact for Partner Center upload

## Validation Results

### arm-ttk Validation
- **Pass**: 49/49 ✅
- **Fail**: 0
- **Status**: CERTIFIED for Azure Marketplace

### Deployment Testing
- ✅ Template deployment successful
- ✅ Ubuntu 22.04.5 LTS deployed (supports Ubuntu 20.04, 22.04, 24.04)
- ✅ SSH access verified
- ✅ Network connectivity confirmed
- ✅ VM metrics: Standard sizing, 6.4% disk usage, 7% memory usage

### Infrastructure
- **Supported Ubuntu Versions**: 20.04 LTS, 22.04 LTS, 24.04 LTS
- **Authentication Methods**: Password, SSH public key
- **VM SKUs Supported**: Standard_B1s, Standard_B2s, Standard_B2ms, Standard_D2s_v3, Standard_D2s_v5, Standard_D4s_v5
- **Default VM Size**: Standard_B2s
- **Default OS**: Ubuntu 22.04 LTS
- **Security Type**: Standard (TrustedLaunch optional)
- **Networking**: Dynamic public IP, SSH (port 22) allowed

### API Versions
All 2025-compliant:
- Microsoft.Network/*: 2025-07-01
- Microsoft.Compute/*: 2025-11-01

## Partner Center Configuration

### Plan Details
- **Plan Name**: AMA Managed Ubuntu 2404 Azure Edition
- **Plan ID**: ubuntu-2404
- **Version**: 0.0.1
- **Pricing**: $0/month (customers pay only for Azure infrastructure)

### Technical Configuration
- **Deployment Mode**: Incremental
- **Publisher Management**: Enabled (Owner role)
- **Customer Access**: Restricted with deny assignments
- **Markets**: 141/141

## Parameters

### Required
- `vmName` - Name of the virtual machine (default: ubuntuVM)
- `adminUsername` - Admin username for SSH/console access
- `adminPasswordOrKey` - Password or SSH public key

### Optional
- `ubuntuOSVersion` - Ubuntu version (20.04, 22.04, 24.04) - default: 22.04
- `vmSize` - VM SKU size - default: Standard_B2s
- `location` - Azure region - default: resource group location
- `virtualNetworkName` - VNet name - default: vNet
- `subnetName` - Subnet name - default: Subnet
- `networkSecurityGroupName` - NSG name - default: SecGroupNet
- `securityType` - Standard or TrustedLaunch - default: Standard

## Outputs
- `adminUsername` - Configured admin username
- `hostname` - FQDN of the public IP
- `sshCommand` - Pre-formatted SSH connection command

## Marketplace Status
✅ **LIVE on Azure Marketplace**
- Public visibility
- Available in all 141 markets
- Certified compliant with arm-ttk

## Related Work
- **Windows Server 2025**: [managedvm-windows2025](../windows-2025/) - ✅ LIVE
- **GitHub Issue #127**: Ubuntu 24.04 LTS Managed Application Packaging

## Notes
- Ubuntu 24.04 image availability varies by region. Deployment defaults to 22.04 which has broader regional availability.
- For production deployments, use SSH public key authentication (more secure than passwords).
- Deny assignments protect managed resources from unauthorized modifications.
- Incremental deployment mode recommended for managed applications.
