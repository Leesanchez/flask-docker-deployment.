@description('Name of the Azure Container Registry')
param containerRegistryName string

@description('Name of the App Service Plan')
param appServicePlanName string

@description('Name of the Web App')
param webAppName string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Image name for the container in ACR')
param containerImageName string = 'flask-docker-app'

@description('Image version for the container in ACR')
param containerImageVersion string = 'latest'

@description('ACR admin username')
param acrAdminUsername string

@description('ACR admin password')
param acrAdminPassword string

// Azure Container Registry
resource acr 'Microsoft.ContainerRegistry/registries@2022-09-01' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Standard'
  }
  adminUserEnabled: true
}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    capacity: 1
    family: 'B'
    name: 'B1'
    size: 'B1'
    tier: 'Basic'
  }
  kind: 'Linux'
  reserved: true
}

// Web App
resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerImageName}:${containerImageVersion}'
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${containerRegistryName}.azurecr.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: acrAdminUsername
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: acrAdminPassword
        }
      ]
    }
  }
}
