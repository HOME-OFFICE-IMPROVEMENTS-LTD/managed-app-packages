# managed-app-packages

Production-quality Azure Marketplace Managed Application packages for **HOME-OFFICE-IMPROVEMENTS-LTD (hoiltd)**.

## Package Status

| Package | Source | arm-ttk | Deployed | Partner Center | Version |
|---------|--------|---------|----------|----------------|---------|
| debian-13 | `debian-13/` | ✅ PASS | ✅ uksouth | ✅ v0.0.2 uploaded | 0.0.2 |
| ubuntu | `ubuntu/` | ✅ PASS | ⏳ pending | ⏳ pending | 0.0.1 |
| postgresql-flexible-vnet | `postgresql-quickstart-source/flexible-postgresql-with-vnet/` | ✅ PASS | ✅ uksouth + SE | ✅ v0.0.6 live | 0.0.6 |
| rhel-9 | `rhel-9/` | ⚠️ needs rebuild | ❌ | ❌ | — |
| almalinux-10 | `almalinux-10/` | ⚠️ needs rebuild | ❌ | ❌ | — |
| rocky-10 | `rocky-10/` | ⚠️ needs rebuild | ❌ | ❌ | — |
| sles-15 | `sles-15/` | ⚠️ needs rebuild | ❌ | ❌ | — |
| windows-2025 | `windows-2025/` | ⚠️ not reviewed | ❌ | ❌ | — |

## Package Workflow

1. `main.bicep` is source of truth — derive from `debian-13/main.bicep` (gold standard)
2. `az bicep lint` → `az bicep build --outfile mainTemplate.json`
3. `az bicep generate-params --outfile azuredeploy.parameters.json --include-params all`
4. Fill `azuredeploy.parameters.json` locally (gitignored — never commit)
5. `Test-AzTemplate -TemplatePath .` (arm-ttk directory)
6. `Test-AzMarketplacePackage -templatePath './managedvm-<name>.zip'` (arm-ttk zip)
7. Portal sandbox test (https://portal.azure.com/#view/Microsoft_Azure_CreateUIDef/SandboxBlade)
8. Real deployment + SSH/RDP verify
9. Zip flat: `mainTemplate.json` + `createUiDefinition.json` only
10. Upload to **alsourillc** first, test, then publish on **hoiltd**

## Rules

- `azuredeploy.parameters.json` is **gitignored** — contains SSH keys / passwords
- Zip naming: `managedvm-<name>.zip`; versioned archive: `managedvm-<name>-<version>.zip`
- Gold standard template: `debian-13/` — all new packages must match its structure
- Always test on `alsourillc` before publishing on `hoiltd`