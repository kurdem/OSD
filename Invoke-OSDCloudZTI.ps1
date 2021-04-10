Write-Host  -ForegroundColor Cyan "Starting OSDCloud PreAction"
Start-Sleep -Seconds 5

Write-Host  -ForegroundColor Cyan "Ejecting ISO"
Start-Sleep -Seconds 5

Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise

Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction"
Start-Sleep -Seconds 5

Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil restart