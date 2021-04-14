<#
    Because the example to create a Naming Convention Policy on Management Group scope the code in the New-AzDeployment Function uses the New-AzManagementGroupDeployment cmdlet.
    Below code will deploy the policy definition at the ES management group scope.
    Link: https://github.com/Azure/Enterprise-Scale/blob/main/docs/Deploy/deploy-new-arm.md#how-to-deploy-arm-templates-with-azops
#>

#region Deploy Naming Convention Policy at Management Group 'ES' Scope
$parameters = @{
    'TemplateFile'                = 'C:\Users\stefstr\Documents\GitHub\ES-IAB\azops\Tenant Root Group (496f0b27-4fa4-4c3d-8bbe-19c4b6875c81)\ES (ES)\policyDef-NamingConvention.json'
    'TemplateParameterFile'       =  'C:\Users\stefstr\Documents\GitHub\ES-IAB\azops\Tenant Root Group (496f0b27-4fa4-4c3d-8bbe-19c4b6875c81)\ES (ES)\policyDef-NamingConvention.parameters.json'
    'Location'                    = 'westeurope'
    'ManagementGroupId'           = 'ES'
    'SkipTemplateParameterPrompt' = $true
    'Debug'                       = $true
}

New-AzManagementGroupDeployment @parameters
#endregion