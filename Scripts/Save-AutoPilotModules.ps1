#===================================================================================================
#   Scripts/Save-AutoPilotModules.ps1
#===================================================================================================
Write-Host -ForegroundColor DarkCyan    "================================================================="
Write-Host -ForegroundColor White       "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) " -NoNewline
Write-Host -ForegroundColor Green       "Scripts/Save-AutoPilotModules.ps1"

Save-Module -Name WindowsAutoPilotIntune -Path 'C:\Program Files\WindowsPowerShell\Modules'
if (-NOT (Test-Path 'C:\Program Files\WindowsPowerShell\Scripts')) {
    New-Item -Path 'C:\Program Files\WindowsPowerShell\Scripts' -ItemType Directory -Force | Out-Null
}
Save-Script -Name Get-WindowsAutoPilotInfo -Path 'C:\Program Files\WindowsPowerShell\Scripts'