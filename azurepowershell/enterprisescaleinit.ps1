#https://github.com/cofomosteve/EnterpriseSclaleDev/blob/main/docs/Deploy/setup-azuredevops.md
#Create Service Principal and assign Owner role to Tenant root scope ("/")
$servicePrincipal = New-AzADServicePrincipal -Role Owner -Scope / -DisplayName AzOps

#Prettify output to print in the format for AZURE_CREDENTIALS to be able to copy in next step.
$servicePrincipalJson = [ordered]@{
    clientId = $servicePrincipal.ApplicationId
    displayName = $servicePrincipal.DisplayName
    name = $servicePrincipal.ServicePrincipalNames[1]
    clientSecret = [System.Net.NetworkCredential]::new("", $servicePrincipal.Secret).Password
    tenantId = (Get-AzContext).Tenant.Id
    subscriptionId = (Get-AzContext).Subscription.Id
} | ConvertTo-Json
#Write-Output $servicePrincipalJson
$escapedServicePrincipalJson = $servicePrincipalJson.Replace('"','\"')
Write-Output $escapedServicePrincipalJson


{
    \"clientId\": \"e3270824-1103-4a08-b2ad-6eab71bc7b9d\",
    \"displayName\": \"AzOps\",
    \"name\": \"http://AzOps\",
    \"clientSecret\": \"688bc117-64f4-495a-a1f3-784704b1d942\",
    \"tenantId\": \"4dbda3f1-592e-4847-a01c-1671d0cc077f\",
    \"subscriptionId\": \"2830c1bb-dbc2-41d3-bf92-616ef65f80bc\"
  }

########################################
# Configure the AzureAD directory role #
########################################

#Install the Module *If Required*
Install-Module -Name AzureAD #Do this in PowerShell as admin

#Connect to Azure Active Directory
$AzureAdCred = Get-Credential
Connect-AzureAD -Credential $AzureAdCred

#Get AzOps Service Principal from Azure AD
Write-Output = Get-AzureADServicePrincipal -Filter "DisplayName eq 'AzOps'"

#Get Azure AD Directory Role
$DirectoryRole = Get-AzureADDirectoryRole -Filter "DisplayName eq 'Directory Readers'"
#$DirectoryRole = Get-AzureADDirectoryRole | Where-Object {$_.DisplayName -eq "Directory Readers"} #If the line above doesn't work with the Filter param, then do this.

if ($DirectoryRole -eq $NULL) {
    Write-Output "Directory Reader role not found. This usually occurs when the role has not yet been used in your directory"
    Write-Output "As a workaround, try assigning this role manually to the AzOps App in the Azure portal"
}
else {
    #Add service principal to Directory Role
    Add-AzureADDirectoryRoleMember -ObjectId $DirectoryRole.ObjectId -RefObjectId $aadServicePrincipal.ObjectId
}
