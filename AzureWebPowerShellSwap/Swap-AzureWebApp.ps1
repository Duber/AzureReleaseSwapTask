[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
    [String] [Parameter(Mandatory = $true)]
    $ConnectedServiceName,

    [String] [Parameter(Mandatory = $true)]
    $WebSiteName,

    [String] [Parameter(Mandatory = $false)]
    $WebSiteLocation,

    [String] [Parameter(Mandatory = $false)]
    $Slot1,

    [String] [Parameter(Mandatory = $false)]
    $Slot2,

    [String] [Parameter(Mandatory = $false)]
    $AdditionalArguments
)

# Import the Task.Common and Task.Internal dll that has all the cmdlets we need for Build
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

Write-Verbose "Entering script Swap-AzureWebApp.ps1"

Write-Host "ConnectedServiceName= $ConnectedServiceName"
Write-Host "WebSiteName= $WebSiteName"
Write-Host "Slot1= $Slot1"
Write-Host "Slot2= $Slot2"
Write-Host "AdditionalArguments= $AdditionalArguments"

$swapAzureWebsiteError = $null

#Swap WebApp slots
$azureCommand = "Switch-AzureWebsiteSlot"
$azureCommandArguments = "-Name `"$WebSiteName`" -Force"
if ($Slot1)
{
    $azureCommandArguments = "$azureCommandArguments -Slot1 `"$Slot1`""
}
if ($Slot2)
{
    $azureCommandArguments = "$azureCommandArguments -Slot2 `"$Slot2`""
}
if ($AdditionalArguments)
{
    $azureCommandArguments = "$azureCommandArguments  $AdditionalArguments"
}
$azureCommandArguments = "$azureCommandArguments -ErrorVariable swapAzureWebsiteError"
$finalCommand = "$azureCommand $azureCommandArguments"
Write-Host "$finalCommand"
Invoke-Expression -Command $finalCommand

if (!$swapAzureWebsiteError) 
{
     Write-Host "Swap success"
}
Write-Verbose "Leaving script Swap-AzureWebApp.ps1"