**New-AzResourceGroup -Name RG01Steve -Location "South Central US"
*
* get all Management Group hierarchie from Root

New-Variable -Name "COFOMgnGroup" -Visibility Public -Value  ""
$COFOMgnGroup = Get-AzManagementGroup -GroupId 4dbda3f1-592e-4847-a01c-1671d0cc077f -Expand -Recurse
$COFOMgnGroup
**Dislay all variable
Get-Variable COFO*

** script qui parcours les management group et deplace les subscription a la racine, puis supprimer les management groupe et les ressource groupe de enterprise scale