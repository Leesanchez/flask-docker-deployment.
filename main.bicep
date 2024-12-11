resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-09-01' = {
  name: 'practicalacr'
  location: 'West Europe'
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'flask-app-service-plan'
  location: 'West Europe'
  sku: {
    name: 'B1'
    tier: 'Basic'
    capacity: 1
  }
  kind: 'Linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'flask-webapp'
  location: 'West Europe'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistry.name}.azurecr.io/flask-docker-app:latest'
    }
  }
}
