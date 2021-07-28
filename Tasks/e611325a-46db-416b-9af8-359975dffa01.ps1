Write-Host  -ForegroundColor Cyan 'Invoke-OSDCloud Example'
Start-Sleep -Seconds 5
#=======================================================================
#   Start-OSDCloudGUI
#=======================================================================
Invoke-OSDCloud
#=======================================================================
#   Restart-Computer
#=======================================================================
Start-Sleep -Seconds 10
Restart-Computer