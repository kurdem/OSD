$GitHubRepo = 'https://github.com/OSDeploy/OSDCloud/blob/main'
$GitHubScript = 'Start-OSDCloud.ps1'

Write-Host "Starting $GitHubRepo/$GitHubScript" -Foregroundcolor Cyan

Write-Host ""
#===================================================================================================
#   Get Location
#===================================================================================================
$GetPSScriptRoot = Get-Item $PSScriptRoot
$GetPSDrive = ($GetPSScriptRoot).PSDrive
$GetConnect = ($GetPSScriptRoot).FullName
$DeployRoot = (Get-Item $PSScriptRoot).parent.FullName
$DeployPath = ($DeployRoot -split ":")[1]
#===================================================================================================
#   Start Menu
#===================================================================================================
Clear-Host
Write-Host -ForegroundColor DarkCyan "================================================================="
if ($GetUSBDisk) {
    Write-Host "BHIMAGE Connect on $DeployRoot [$($GetUSBDisk.FriendlyName)]" -ForegroundColor Cyan
} else {
    Write-Host "BHIMAGE Connect on $DeployRoot" -ForegroundColor Cyan
}
Write-Host "FOR TESTING ONLY, NON-PRODUCTION"
#Write-Host -ForegroundColor DarkGray "PSDrive = $GetPSDrive"
#Write-Host -ForegroundColor DarkGray "Connect = $GetConnect"
Write-Host -ForegroundColor DarkCyan "================================================================="

Write-Host " A  " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "Windows AutoPilot"

Write-Host " AD " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "Windows AutoPilot Developer"

Write-Host " 64 " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "Windows 10 1909 x64"

Write-Host " X  " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "Exit"

Write-Host ""

do {
    $BuildImage = Read-Host -Prompt "Enter an option, or X to Exit"
}
until (
    (
        ($BuildImage -eq 'A') -or #AutoPilot
        ($BuildImage -eq 'AD') -or #AutoPilot DEV Testing
        ($BuildImage -eq '64') -or #Standard Image Testing
        ($BuildImage -eq 'X')
    ) 
)

Write-Host ""

if ($BuildImage -eq 'X') {
    Write-Host ""
    Write-Host "Adios!" -ForegroundColor Cyan
    Write-Host ""
    Break
}
if ($BuildImage -ne 'X') {

}
#===================================================================================================
#   Define Build Process
#===================================================================================================
$BuildName              = 'Default'
$RequiresWinPE          = $true
$RequiresUEFI           = $false
$ApplyDrivers           = $true
$ApplyAutoPilot         = $false
$ApplyAutoPilotDEV      = $false
$ApplyUnattend          = $true

if ($BuildImage -eq 'A') {
    $BuildName          = 'AutoPilot for Existing Devices'
    $RequiresUEFI       = $true
    $ApplyAutoPilot     = $true
}
if ($BuildImage -eq 'AD') {
    $BuildName          = 'AutoPilot DEV for Existing Devices'
    $RequiresUEFI       = $true
    $ApplyAutoPilotDEV  = $true
}
if ($BuildImage -eq '64') {
    $BuildName          = 'Windows 10 1909 x64'
}
<# if ($BuildImage -eq 'WU') {
    $BuildName          = 'Windows OS Unattend'
    $ApplyUnattend      = $true
} #>