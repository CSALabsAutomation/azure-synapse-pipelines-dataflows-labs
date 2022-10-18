param(
    [string]
    $Resourcegroupname
)
$WorkSpace = Get-AzResource -ResourceGroupName $Resourcegroupname -Resourcetype Microsoft.Synapse/workspaces
$WorkSpacename = $WorkSpace.Name
$dataset1 = Get-AzSynapseDataset -WorkspaceName $WorkSpacename -Name adworksraw
if ($dataset1)
{
    Write-Host "dataset adworksraw created"
}
else
{
    Write-Host "dataset adworksraw not created"
}
$dataset2 = Get-AzSynapseDataset -WorkspaceName $WorkSpacename -Name raw
if ($dataset2)
{
    Write-Host "dataset raw created"
}
else
{
    Write-Host "dataset raw not created"
}
$df = Get-AzSynapseDataFlow -WorkspaceName $WorkSpacename -Name adworks_DF
  if ($df.Name -eq "adworks_DF") { 
    Write-Host "Data flow adworks_DF created" }
else { Write-Host "Data flow adworks_DF not created" }

$pipeline = Get-AzSynapsePipeline -WorkspaceName $WorkSpacename -Name Load_CSV_data_to_adworks
if ($pipeline)
{
    Write-Host "pipeline created"
}
else
{
    Write-Host "pipeline not created"
}
