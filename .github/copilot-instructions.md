# Copilot Instructions — managed-app-packages

## Repository Owner

**This is the HOME-OFFICE-IMPROVEMENTS-LTD (HOILTD) proprietary repository.**

- **Organisation:** HOME-OFFICE-IMPROVEMENTS-LTD (HOILTD)
- **Owner / Lead Developer:** msalsouri
- **Business type:** ISV · CSP · MSP
- **GitHub repo:** `git@github.com:HOME-OFFICE-IMPROVEMENTS-LTD/managed-app-packages.git`
- **Remote name (in Mastering-the-Marketplace workspace):** `hoiltd`

> ⚠️ **NEVER push to `microsoft/Mastering-the-Marketplace`** — that is the upstream reference repo (read-only).
> **ALWAYS push to the `hoiltd` remote** → `HOME-OFFICE-IMPROVEMENTS-LTD/managed-app-packages`.

---

## Purpose

Production-quality **Azure Marketplace Managed Application packages** for the HOILTD ISV/MSP business.  
Each package is a fully self-contained managed app offer: Bicep source, compiled ARM JSON, createUiDefinition, and scripts — all arm-ttk clean.

---

## Repository Layout

```
managed-app-packages/
├── .github/
│   └── copilot-instructions.md   ← you are here
├── debian-13/                    ← gold standard Linux VM template (base for all VMs)
├── ubuntu-2404/
├── ubuntu-2204/
├── windows-2025/                 ← gold standard Windows VM template
├── dokku/                        ← first application workload package
│   ├── main.bicep                ← source of truth
│   ├── mainTemplate.json         ← compiled from main.bicep  (committed)
│   ├── azuredeploy.json          ← copy of mainTemplate.json (committed, for VS Code right-click)
│   ├── azuredeploy.parameters.bicepparam  ← local test params (committed, no secrets)
│   ├── azuredeploy.parameters.json        ← local test params JSON (gitignored — may contain secrets)
│   ├── createUiDefinition.json
│   ├── metadata.json
│   ├── scripts/
│   │   └── deploy_dokku.sh
│   └── managedapp-dokku.zip      ← Partner Center upload artifact
└── ...
```

---

## Gold Standard Checklist (every package MUST have)

- [ ] `securityProfileJson` includes `securityType: securityType` (not just `uefiSettings`)
- [ ] GuestAttestation extension: Linux = `Microsoft.Azure.Security.LinuxAttestation`, Windows = `Microsoft.Azure.Security.WindowsAttestation`
- [ ] Standard/Static public IP (Basic SKU retiring Sept 2025)
- [ ] `tagsByResource[?'ResourceType'] ?? {}` safe-access on ALL resources
- [ ] Dynamic resource names: `${vmName}-vnet`, `${vmName}-nic`, `${vmName}-nsg`, `${vmName}-ip`
- [ ] Managed boot diagnostics (no storage account)
- [ ] `dependsOn: [vmExtension]` on CustomScript — GuestAttestation must run first
- [ ] `_artifactsLocation` default = GitHub raw URL (NOT `deployment().properties.templateLink.uri`)
- [ ] arm-ttk: 0 failures on both directory and zip

---

## The `_artifactsLocation` Rule

**Always use the GitHub raw URL as the default value:**

```bicep
param _artifactsLocation string = 'https://raw.githubusercontent.com/HOME-OFFICE-IMPROVEMENTS-LTD/managed-app-packages/main/<package-name>/'
```

**Never use** `deployment().properties.templateLink.uri` — ARM validates default-value expressions
even when the parameter is explicitly provided, causing inline (VS Code) deployments to fail
with `"templateLink doesn't exist"`.

---

## 6-Gate Workflow (every package before Partner Center upload)

1. `az bicep build` — no errors
2. arm-ttk directory — 0 failures
3. arm-ttk zip — 0 failures
4. createUiDefinition sandbox test
5. Real Azure deployment (`azuredeploy.json` + `azuredeploy.parameters.bicepparam`)
6. Partner Center upload

---

## Git Workflow

```bash
# Working branch
git checkout feat/managed-app-vm-linux

# Push to HOILTD repo (not microsoft upstream!)
git push hoiltd feat/managed-app-vm-linux:main

# Remote setup (if starting fresh)
git remote add hoiltd git@github.com:HOME-OFFICE-IMPROVEMENTS-LTD/managed-app-packages.git
```

---

## arm-ttk Location

```
/home/msalsouri/Projects/Mastering-the-Marketplace/arm-ttk/arm-ttk/arm-ttk.psd1
```

Run:
```powershell
Import-Module /home/msalsouri/Projects/Mastering-the-Marketplace/arm-ttk/arm-ttk/arm-ttk.psd1 -Force
Test-AzTemplate -TemplatePath './managed-app-packages/<package>'
Test-AzTemplate -TemplatePath './managed-app-packages/<package>/managedapp-<name>.zip'
```
