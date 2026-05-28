// ============================================================
// HOILTD Managed Service — Azure Lighthouse Delegation
// Deploys at subscription scope so HOILTD can manage
// the customer's Azure subscription via Azure Lighthouse.
//
// Partner Center offer type: Managed Service
// Scope: subscription
// ============================================================
targetScope = 'subscription'

// ── Parameters ──────────────────────────────────────────────

@description('Name of the HOILTD managed service offer shown in Lighthouse.')
param mspOfferName string = 'HOILTD Managed Azure Services'

@description('Description of the managed service offer.')
param mspOfferDescription string = 'Home & Office Improvements Ltd (HOILTD) provides fully managed Azure services including governance, security, monitoring, and 24/7 support. This delegation enables HOILTD engineers to manage your Azure subscription on your behalf.'

@description('HOILTD tenant ID — the managing tenant.')
param managingTenantId string = '8d8fc190-bad7-469a-b9ba-fee5c60b25f4'

// ── HOILTD Authorization Groups ──────────────────────────────
// These are the HOILTD Entra ID groups that get access to the customer subscription.
// Role definitions: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles

var hoiltdAuthorizations = [
  {
    // hoi-sg-lighthouse-administrators — full management access (all Mohammed accounts)
    principalId: '51f640b2-1d38-4952-b1ca-1935e53622b7'
    principalIdDisplayName: 'HOILTD Lighthouse Administrators'
    roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
  }
  {
    // HOI-AZ-PLATFORM-OWNERS — platform engineering access
    principalId: '5b82103b-87da-4422-9872-7d56a51c38f8'
    principalIdDisplayName: 'HOILTD Platform Engineers'
    roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7' // Reader
  }
  {
    // HOI-PIM-ServiceAdmins — elevated access via PIM (Just-In-Time)
    principalId: '00fb43a1-9ddf-4cc4-810f-18aca6b13e89'
    principalIdDisplayName: 'HOILTD Service Administrators (PIM)'
    roleDefinitionId: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9' // User Access Administrator
  }
]

// ── Resources ────────────────────────────────────────────────

resource registrationDefinition 'Microsoft.ManagedServices/registrationDefinitions@2022-10-01' = {
  name: guid(mspOfferName, managingTenantId)
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managingTenantId
    authorizations: hoiltdAuthorizations
  }
}

resource registrationAssignment 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: guid(registrationDefinition.id)
  properties: {
    registrationDefinitionId: registrationDefinition.id
  }
}

// ── Outputs ──────────────────────────────────────────────────

output mspOfferName string = mspOfferName
output registrationDefinitionId string = registrationDefinition.id
output lighthousePortalUrl string = 'https://lighthouse.microsoft.com'
