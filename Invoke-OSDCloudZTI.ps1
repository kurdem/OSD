Write-Host  -ForegroundColor Cyan "Starting OSDCloud Startup"
Start-Sleep -Seconds 5

if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Cyan "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Write-Host  -ForegroundColor Cyan "Updating OSD PowerShell Module"
Install-Module OSD -Force
Import-Module OSD -Force
Start-Sleep -Seconds 5

Write-Host  -ForegroundColor Cyan "Ejecting ISO"
Start-Sleep -Seconds 5

Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise

Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction"
Start-Sleep -Seconds 5

Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil restart