Write-Host  -ForegroundColor Cyan 'Start-OSDCloud with Params AutopilotCMD Reboot AutopilotOOBE'
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


#Create AutopilotOOBE Config
$AutopilotOOBEJson = @'
{
    "AddToGroup":  "",
    "AddToGroupOptions":  null,
    "Assign":  {
                   "IsPresent":  true
               },
    "AssignedUser":  "",
    "AssignedUserExample":  "someone@example.com",
    "AssignedComputerName":  "",
    "AssignedComputerNameExample":  "Azure AD Join Only",
    "Disabled":  null,
    "Demo":  {
                 "IsPresent":  false
             },
    "GroupTag":  "Akos",
    "GroupTagOptions":  [
                            "Akos",
                            "Bakos"
                        ],
    "Hidden":  [
                   "AddToGroup",
                   "AssignedComputerName"
               ],
    "PostAction":  "Quit",
    "Run":  "PowerShell",
    "Docs":  "",
    "Title":  "Akos Autopilot Register"
}
'@
$AutopilotOOBEJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json" -Encoding ascii -Force
