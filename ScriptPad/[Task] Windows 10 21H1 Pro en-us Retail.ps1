#================================================
#   [PreOS] Install and Import OSD Module
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
#   [PostOS] AutopilotOOBE Configuration Staging
#================================================
$AutopilotOOBEJson = @'
{
    "Assign":  {
                   "IsPresent":  true
               },
    "GroupTag":  "Enterprise",
    "GroupTagOptions":  [
                            "Development",
                            "Enterprise"
                        ],
    "Hidden":  [
                   "AddToGroup",
                   "AssignedComputerName",
                   "AssignedUser",
                   "PostAction"
               ],
    "PostAction":  "Quit",
    "Run":  "NetworkingWireless",
    "Docs":  "https://autopilotoobe.osdeploy.com/",
    "Title":  "OSDeploy Autopilot Registration"
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$AutopilotOOBEJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json" -Encoding ascii -Force
#================================================
#   [PostOS] OOBEDeploy Configuration Staging
#================================================
$OOBEDeployJson = @'
{
    "Autopilot":  {
                      "IsPresent":  true
                  },
    "RemoveAppx":  [
                       "CommunicationsApps",
                       "OfficeHub",
                       "People",
                       "Skype",
                       "Solitaire",
                       "Xbox",
                       "ZuneMusic",
                       "ZuneVideo"
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  true
                      },
    "UpdateWindows":  {
                          "IsPresent":  true
                      }
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$OOBEDeployJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json" -Encoding ascii -Force
#================================================
#   [PostOS] OOBEDeploy CMD File
#================================================
$AutopilotCmd = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
start PowerShell -NoL -W Mi
start /wait PowerShell -NoL -C Install-Module OSD -Force
start /wait PowerShell -NoL -C Start-OOBEDeploy
exit
'@
$AutopilotCmd | Out-File -FilePath "C:\Windows\Autopilot.cmd" -Encoding ascii -Force
#================================================
#   [PostOS] Restart-Computer
#================================================
Restart-Computer