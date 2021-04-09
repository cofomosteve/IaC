param appName string = uniqueString(resourceGroup().id)
param appLoc string= resourceGroup().location //= 'eastus'

param globalRedundancy bool = true // defaults to true, but can be overridden

param currentTime string = utcNow()

@minLength(3)
@maxLength(24)

param namePrefix string = 'unique'
var storageAccountName = '${namePrefix}storage001'//'${namePrefix}${uniqueString(resourceGroup().id)}'

resource insights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: 'insights-${appName}'
  kind:'application'
  location: appLoc
  properties: {
      Application_Type: 'web'
  }
}



resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: appLoc
  kind: 'Storage'
  sku: {
    //name: 'Standard_LRS'
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS' // if true --> GRS, else --> LRS
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${stg.name}/default/logs'
  // dependsOn will be added when the template is compiled
}

resource hosting 'Microsoft.Web/serverfarms@2019-08-01' = {
  name: 'hosting-${appName}'
  location: appLoc
  sku: {
      name: 'S1'
  }
}

resource app 'Microsoft.Web/sites@2020-10-01' = {
  name: appName
  location: appLoc
  identity: {
        type: 'SystemAssigned'
    }
    properties: {
        
        siteConfig: {
            appSettings: [
                {
                    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
                    value: insights.properties.InstrumentationKey
                }
            ]
        }
        serverFarmId: hosting.id
    }
}

output appId string = app.id
output storageId string = stg.id // output resourceId of storage account
output makeCapital string = toUpper('all lowercase')
output blobEndpoint string = stg.properties.primaryEndpoints.blob // replacement for reference(...).*
