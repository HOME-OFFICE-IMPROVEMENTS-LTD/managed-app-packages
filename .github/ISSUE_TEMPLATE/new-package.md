---
name: New Package
about: Track work for a new managed application package
title: "feat: add [PACKAGE-NAME] managed app package"
labels: enhancement, new-package
assignees: msalsouri
---

## Package Details

- **Package name**: <!-- e.g. rhel-9 -->
- **Offer type**: Azure Application — Managed Application
- **Publisher image**: <!-- e.g. RedHat/RHEL/9_4-gen2 -->

## Checklist

### Source
- [ ] `main.bicep` created (based on debian-13 template)
- [ ] Image reference verified via `az vm image list`
- [ ] `azuredeploy.json` generated (`az bicep build`)
- [ ] `azuredeploy.parameters.json` generated and filled (gitignored)
- [ ] `metadata.json` created (Partner Center copy sheet)

### UI Definition
- [ ] `createUiDefinition.json` created
- [ ] `Microsoft.Compute.UserNameTextBox` for username
- [ ] `Microsoft.Compute.CredentialsCombo` for SSH/password
- [ ] `Microsoft.Compute.SizeSelector` with correct image reference
- [ ] `Microsoft.Common.InfoBox` on security type
- [ ] `Microsoft.Common.TagsByResource` step
- [ ] `resourceTypes` filter set

### Validation
- [ ] `az bicep lint` — clean
- [ ] `az bicep build → mainTemplate.json` — clean
- [ ] `Test-AzTemplate` — 0 FAIL
- [ ] `Test-AzMarketplacePackage` — 0 FAIL
- [ ] Portal sandbox test passed
- [ ] Real deployment test (`az deployment group create`) — succeeded
- [ ] SSH / RDP verified

### Publishing
- [ ] `managedvm-<name>.zip` built (flat: mainTemplate.json + createUiDefinition.json)
- [ ] Uploaded to Partner Center (alsourillc)
- [ ] Live test passed
- [ ] Published on hoiltd
