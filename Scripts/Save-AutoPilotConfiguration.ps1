#===================================================================================================
#   Scripts/Save-AutoPilotConfiguration.ps1
#===================================================================================================
$AutoPilotConfiguration = Select-AutoPilotJson

if ($AutoPilotConfiguration) {
    $AutoPilotConfiguration
}
#===================================================================================================
#   Scripts/Save-AutoPilotConfiguration.ps1
#===================================================================================================
$PathAutoPilot = 'C:\Windows\Provisioning\AutoPilot'
if (-NOT (Test-Path $PathAutoPilot)) {
    New-Item -Path $PathAutoPilot -ItemType Directory -Force | Out-Null
}
$AutoPilotConfigurationFile = Join-Path $PathAutoPilot 'AutoPilotConfigurationFile.json'
if ($AutoPilotConfiguration) {
    Write-Verbose -Verbose "Setting $AutoPilotConfigurationFile"
    $AutoPilotConfiguration | ConvertTo-Json | Out-File -FilePath $AutoPilotConfigurationFile -Encoding ASCII
}