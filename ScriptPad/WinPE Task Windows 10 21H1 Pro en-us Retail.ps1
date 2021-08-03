#================================================
#   OSDCloud Task Sequence
#   Windows 10 21H1 Pro en-us Retail
#   No Autopilot
#   No Office Deployment Tool
#================================================
#   PreOS
#   Install and Import OSD Module
#================================================
Install-Module OSD -Force
Import-Module OSD -Force
#================================================
#   [OS] Start-OSDCloud with Params
#================================================
$Params = @{
    OSBuild = "21H1"
    OSEdition = "Pro"
    OSLanguage = "en-us"
    OSLicense = "Retail"
    SkipAutopilot = $true
    SkipODT = $true
}
Start-OSDCloud @Params
#================================================
#   WinPE PostOS Sample
#   AutopilotOOBE Offline Staging
#================================================
Install-Module AutopilotOOBE -Force
Import-Module AutopilotOOBE -Force

$Params = @{
    Title = 'OSDeploy Autopilot Registration'
    GroupTag = 'Enterprise'
    GroupTagOptions = 'Development','Enterprise'
    Hidden = 'AddToGroup','AssignedComputerName','AssignedUser','PostAction'
    Assign = $true
    Run = 'NetworkingWireless'
    Docs = 'https://autopilotoobe.osdeploy.com/'
}
AutopilotOOBE @Params
#================================================
#   WinPE PostOS Sample
#   OOBEDeploy Offline Staging
#================================================
$Params = @{
    AutopilotOOBE = $true
    RemoveAppx = "CommunicationsApps","OfficeHub","People","Skype","Solitaire","Xbox","ZuneMusic","ZuneVideo"
    UpdateDrivers = $true
    UpdateWindows = $true
}
Start-OOBEDeploy @Params
#================================================
#   PostOS
#   OOBEDeploy CMD File
#================================================
$OOBEDeployCMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
start PowerShell -NoL -W Mi
start /wait PowerShell -NoL -C Install-Module OSD -Force
start /wait PowerShell -NoL -C Start-OOBEDeploy
exit
'@
$OOBEDeployCMD | Out-File -FilePath "C:\Windows\OOBEDeploy.cmd" -Encoding ascii -Force
#================================================
#   PostOS
#   Restart-Computer
#================================================
Restart-Computer