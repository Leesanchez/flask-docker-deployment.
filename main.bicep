param containerRegistryName string
param location string
param appServicePlanName string
param webAppName string
param acrAdminPassword string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-09-01' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {}
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    tier: 'Basic'
    name: 'B1'
    capacity: 1
  }
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistry.name}.azurecr.io/flask-docker-app:latest'
      appSettings: [
        {
          name: "WEBSITES_ENABLE_APP_SERVICE_STORAGE"
          value: "false"
        }
        {
          name: "DOCKER_REGISTRY_SERVER_URL"
          value: "https://${containerRegistry.name}.azurecr.io"
        }
        {
          name: "DOCKER_REGISTRY_SERVER_USERNAME"
          value: containerRegistry.name
        }
        {
          name: "DOCKER_REGISTRY_SERVER_PASSWORD"
          value: acrAdminPassword
        }
      ]
    }
  }
}
