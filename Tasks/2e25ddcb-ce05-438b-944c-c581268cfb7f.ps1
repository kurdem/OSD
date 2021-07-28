Write-Host  -ForegroundColor Cyan 'Start-OSDCloud with Params'
Start-Sleep -Seconds 5
#=======================================================================
#   Params
#=======================================================================
$Params = @{
    OSBuild = "21H1"
    OSEdition = "Pro"
    OSLanguage = "en-us"
    OSLicense = "Retail"
    SkipAutopilot = $true
    SkipODT = $true
}
#=======================================================================
#   Start-OSDCloudGUI
#=======================================================================
Start-OSDCloud @Params
#=======================================================================
#   Restart-Computer
#=======================================================================
Start-Sleep -Seconds 10
Restart-Computer