param location string = 'southeastasia'
param tenantGuid string = 'ab5eb3d0-6067-40ee-b4c0-a2ce05dbf039'
param appServicePlanName string = 'as-goat-app-service-prod'
param keyVaultName string = 'kv-goat-prod'
param webAppName string = 'wa-animaladoption-prod'
param resourceGroupServicePrincipalManagedApplicationObjectId string = '21e909ff-830f-499b-a4cb-27fb8149b459'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: []
      linuxFxVersion: 'DOTNETCORE|3.1'
      alwaysOn: true
    }
  }
}

var yourAadUserObjectId = 'd87fbd5b-2fa3-4b79-afd5-3d83a3dd2fa6'
var yourAadUserObjectId1 = '6b673b23-0d07-4de6-ba31-01fd30675536'
var yourAadUserObjectId2 = '8d49a2c0-d745-41b5-8d32-345cd13da08c'

var userObjectIdsToGrantAccessPoliciesThatAllowFullControlForAllEntitiesInKeyVault = [
  yourAadUserObjectId
  yourAadUserObjectId1
  yourAadUserObjectId2
]

var identitiesThatRequiredSecretAccessPolicies = [
  resourceGroupServicePrincipalManagedApplicationObjectId
]

var fullControlForAllEntitiesInKeyVaultAccessPolicies = [for userObjectId in userObjectIdsToGrantAccessPoliciesThatAllowFullControlForAllEntitiesInKeyVault: {
  tenantId: tenantGuid
  objectId: userObjectId
  permissions: {
    keys: [
      'get'
      'list'
      'update'
      'create'
      'import'
      'delete'
      'recover'
      'backup'
      'restore'
    ]
    secrets: [
      'get'
      'list'
      'set'
      'delete'
      'recover'
      'backup'
      'restore'
    ]
    certificates: [
      'get'
      'list'
      'update'
      'create'
      'import'
      'delete'
      'recover'
      'backup'
      'restore'
      'managecontacts'
      'manageissuers'
      'getissuers'
      'listissuers'
      'setissuers'
      'deleteissuers'
    ]
  }
}]

var accessForSecretsInKeyVaultAccessPolicies = [for identityObjectId in identitiesThatRequiredSecretAccessPolicies: {
  tenantId: tenantGuid
  objectId: identityObjectId
  permissions: {
    keys: []
    secrets: [
      'get'
      'list'
      'set'
      'delete'
      'recover'
      'backup'
      'restore'
    ]
    certificates: []
  }
}]

var keyVaultAccessPolicies = union(fullControlForAllEntitiesInKeyVaultAccessPolicies, accessForSecretsInKeyVaultAccessPolicies)

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenantGuid
    softDeleteRetentionInDays: 90
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableRbacAuthorization: false
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    accessPolicies: keyVaultAccessPolicies
  }
}
