targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('The location where the resources will be created.')
param location string = resourceGroup().location

@description('Optional. The name of the service bus namespace. If set, it overrides the name generated by the template.')
param serviceBusName string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('The name of the service bus topic.')
param serviceBusTopicName string

@description('The name of the service bus topic\'s authorization rule.')
param serviceBusTopicAuthorizationRuleName string

@description('The name of the service for the backend processor service. The name is used as Dapr App ID and as the name of service bus topic subscription.')
param backendProcessorServiceName string

// ------------------
// RESOURCES
// ------------------

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: serviceBusName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
}

resource serviceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2021-11-01' = {
  name: serviceBusTopicName
  parent: serviceBusNamespace
}

resource serviceBusTopicAuthRule 'Microsoft.ServiceBus/namespaces/topics/authorizationRules@2021-11-01' = {
  name: serviceBusTopicAuthorizationRuleName
  parent: serviceBusTopic
  properties: {
    rights: [
      'Manage'
      'Send'
      'Listen'
    ]
  }
}

resource serviceBusTopicSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {
  name: backendProcessorServiceName
  parent: serviceBusTopic
}

// ------------------
// OUTPUTS
// ------------------

@description('The name of the service bus namespace.')
output serviceBusName string = serviceBusNamespace.name

@description('The name of the service bus topic.')
output serviceBusTopicName string = serviceBusTopic.name

@description('The name of the service bus topic\'s authorization rule.')
output serviceBusTopicAuthorizationRuleName string = serviceBusTopicAuthRule.name