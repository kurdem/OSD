Write-Host  -ForegroundColor Cyan 'Start-OSDCloud with Params and Reboot'
Start-Sleep -Seconds 5

#Start-OSDCloud
$Params = @{
    OSBuild = "21H1"
    OSEdition = "Pro"
    OSLanguage = "en-us"
    OSLicense = "Retail"
    SkipAutopilot = $true
    SkipODT = $true
}
Start-OSDCloud @Params

#Need to add copy JSON file to "C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json"

#Create Autopilot.cmd
$AutopilotCmd = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
start PowerShell -NoL -W Mi
start /wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force
start /wait PowerShell -NoL -C Start-AutopilotOOBE
'@


#Restart Computer
Start-Sleep -Seconds 10
Restart-Computer