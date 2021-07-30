Write-Host  -ForegroundColor Cyan 'Demo OSDCloud Audit Mode OOBEDeploy'
Start-Sleep -Seconds 10
#=======================================================================
#   Set-DisRes
#=======================================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor DarkCyan 'Setting Virtual Machine Display Resolution to 1600x'
    Write-Host  -ForegroundColor DarkCyan 'Set-DisRes 1600'
    Set-DisRes 1600
}
#=======================================================================
#   Update the OSD Module
#=======================================================================
Write-Host  -ForegroundColor DarkCyan 'Install-Module OSD -Force'
Install-Module OSD -Force
Write-Host  -ForegroundColor Cyan 'Import-Module OSD -Force'
Import-Module OSD -Force
#=======================================================================
#   Start-OSDCloudGUI
#=======================================================================
Start-OSDCloudGUI

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Cyan 'WinPE will reboot in 15 seconds'
Start-Sleep -Seconds 15
Write-Host  -ForegroundColor DarkCyan 'Restart-Computer'
Restart-Computer