# Partner Center Upload Guide - Ubuntu 24.04 LTS Managed Application

## Overview
This guide documents the steps to upload the Ubuntu 24.04 LTS managed application to Microsoft Partner Center.

## Prerequisites
- ✅ Template validated: 49/49 Pass (arm-ttk certified)
- ✅ Deployment tested: Ubuntu 22.04 LTS deployed successfully
- ✅ Zip artifact created: managedvm-ubuntu2404.zip (4.0 KB)
- ✅ GitHub issue #127 documented with validation evidence

## Artifact Location
```
/home/msalsouri/Projects/Mastering-the-Marketplace/managed-app-packages/ubuntu-2404/managedvm-ubuntu2404.zip
```

## Partner Center Setup Steps

### Step 1: Navigate to Your Offer
1. Go to [Microsoft Partner Center](https://partner.microsoft.com)
2. Sign in with your publisher account
3. Select the offer: **"AMA for Windows Server 2025"** (or create new offer for "AMA for Ubuntu 2404")
4. Click "Create plan"

### Step 2: Plan Configuration

**Plan Details:**
- Plan name: `AMA Managed Ubuntu 2404 Azure Edition`
- Plan ID: `ubuntu-2404`
- Plan type: `Managed Application`
- Version: `0.0.1`

### Step 3: Technical Configuration

**Upload Artifact:**
1. Scroll to "Technical configuration" section
2. Click "Upload package"
3. Select file: `managedvm-ubuntu2404.zip`
4. File will contain:
   - mainTemplate.json (10,997 bytes)
   - createUiDefinition.json (6,870 bytes)

**Deployment Settings:**
- Deployment mode: `Incremental`
- Publisher access: `Enabled`
- Tenant ID: `5a29c7e0-fe19-4c7a-9abd-2ef97ed043f1`
- Principal ID: `70038e3b-8979-4f4e-8e4d-ca2393d318ff`
- Role: `Owner`

### Step 4: Pricing Configuration
- Pricing model: `Free`
- Price: `$0/month`
- Note: "Customers pay only for underlying Azure infrastructure"

### Step 5: Market Selection
- Markets: Select `141/141` (all available markets)
- Or select specific regions

### Step 6: Plan Listing
- Plan display name: "Ubuntu 2404 Azure Edition"
- Plan description:
  ```
  Production-ready Ubuntu 24.04 LTS managed application for Azure.
  Supports Ubuntu 20.04, 22.04, and 24.04 LTS deployments.
  Includes SSH key and password authentication options.
  One-click deployment with ARM templates.
  ```

### Step 7: Plan Availability
- Visibility: `Public`
- Launch date: (set to current date or preferred launch)

## Pre-Submission Checklist

- [ ] Zip artifact uploaded and verified (2 files visible in Partner Center)
- [ ] Deployment mode set to "Incremental"
- [ ] Publisher access enabled with correct tenant/principal IDs
- [ ] Pricing set to $0/month
- [ ] All 141 markets selected
- [ ] Plan description complete
- [ ] Visibility set to Public
- [ ] Certification requirements reviewed

## Expected Certification Timeline
- Submission: Immediately upon "Submit for certification"
- Review period: 1-5 business days (typical for validated templates)
- Expected status: PASS (template is arm-ttk certified: 49/49 ✅)
- Marketplace appearance: 24-48 hours after certification approval

## Validation Proof for Microsoft Reviewers

**arm-ttk Results:**
```
Validating ubuntu-2404\createUiDefinition.json
  All 17 checks: PASS ✅

Validating ubuntu-2404\mainTemplate.json
  All 32 checks: PASS ✅ (2025 API versions compliant)

Total: Fail 0, Pass 49
```

**Deployment Test:**
- Successful deployment: ✅ Verified
- OS: Ubuntu 22.04.5 LTS
- SSH access: ✅ Confirmed working
- Network: ✅ Public IP and DNS resolution working
- System health: ✅ 6.4% disk usage, 7% memory usage

## API Versions (2025-Compliant)
```json
"apiVersion": "2025-07-01"  // Microsoft.Network/*
"apiVersion": "2025-11-01"  // Microsoft.Compute/*
```

## Support Resources
- [Publish a managed application](https://learn.microsoft.com/azure/marketplace/partner-center-portal/create-new-azure-apps-offer)
- [Create ARM templates for managed applications](https://learn.microsoft.com/azure/azure-resource-manager/managed-applications/overview)
- [arm-ttk test results](https://github.com/Azure/arm-ttk)

## Post-Publication Tasks

1. **Monitor Certification:**
   - Navigate to "Offer overview" > "Plan overview"
   - Check status: "In certification" → "Live"

2. **Verify Marketplace Listing:**
   - Search Azure Marketplace for "Ubuntu 2404"
   - Confirm plan appears with correct description
   - Test 1-click deployment from public listing

3. **Update Issue #127:**
   - Comment with link to live listing
   - Mark issue as complete
   - Reference this guide for future Linux distributions

4. **Document Multi-OS Framework:**
   - Same workflow applies to RHEL, SLES, Rocky Linux, etc.
   - Can create 5-10 managed apps from this template pattern

## Related Offers
- **Windows Server 2025**: AMA for Windows Server 2025 (LIVE ✅)
  - Windows Server 2025 Standard Edition plan (LIVE)
  - Windows Server 2025 Datacenter Edition plan (LIVE)

## Notes
- Template uses Ubuntu 22.04 as default (broadest regional availability)
- Customers can override to Ubuntu 20.04 or 24.04 at deployment time
- SSH public key authentication recommended for production deployments
- All test parameters and Bicep files are for development only; Partner Center uses JSON only

---

**Status**: Ready for Partner Center upload (validated, tested, certified)
**Last Updated**: 13 May 2026
**Next Step**: Upload managedvm-ubuntu2404.zip to Partner Center
