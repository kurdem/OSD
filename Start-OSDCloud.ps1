#===================================================================================================
#   Set Global Variables
#===================================================================================================
$Global:StartOSDCloud = Get-Variable

$Global:GitHubUser = $GitHubUser
$Global:GitHubUserPath = "https://raw.githubusercontent.com/$Global:GitHubUser"

$Global:GitHubRepository = $Repository
$Global:GitHubRepositoryPath = "$Global:GitHubUserPath/$Global:GitHubRepository"

$Global:GitHubScript = $Script
$Global:GitHubScriptPath = "$Global:GitHubRepositoryPath/main/$Global:GitHubScript"

$Global:StartOSDCloudFullName = $Url
#===================================================================================================
#   Module Requirements
#===================================================================================================
[Version]$OSDVersionMin = '21.3.10.2'

if ((Get-Module -Name OSD -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1).Version -lt $OSDVersionMin) {
    Write-Warning "OSDCloud requires OSD $OSDVersionMin or newer"
    Write-Warning "Updating OSD PowerShell Module"
}


Break
pause





function Write-TicTock {
    [CmdletBinding()]
    Param ()
    
    $TicTock = Get-Date
    Write-Host -ForegroundColor White "$(($TicTock).ToString('yyyy-MM-dd-HHmmss')) " -NoNewline
}
#===================================================================================================
#   Start-OSDCloud
#===================================================================================================
$GitHubRepo = 'https://github.com/OSDeploy/OSDCloud/blob/main'
$GitHubScript = 'Start-OSDCloud.ps1'
Write-TicTock; Write-Host "$GitHubRepo/$GitHubScript" -Foregroundcolor Cyan
Write-Host -ForegroundColor DarkCyan "================================================================="
Write-Warning "THIS IS CURRENTLY IN DEVELOPMENT.  I'M JUST SHOWING OFF, REALLY"
Write-Warning "FOR TESTING ONLY, NON-PRODUCTION"
Write-Host -ForegroundColor DarkCyan "================================================================="
Write-Host "ENT " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Windows 10 x64 20H1 Enterprise"

Write-Host "EDU " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Windows 10 x64 20H1 Education"

Write-Host "PRO " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Windows 10 x64 20H1 Pro"

Write-Host "1   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Clear-LocalDisk"

Write-Host "2   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    New-OSDisk"

Write-Host "3   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Dell - Download and Update BIOS"

Write-Host "4   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Download Windows 10 ESD - 20H2 x64 Enterprise"

Write-Host "5   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Expand Windows 10 ESD - 20H2 x64 Enterprise"

Write-Host "6   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Dell - Download, Expand, and Apply Driver Cab"

Write-Host "X   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Exit"
Write-Host -ForegroundColor DarkCyan "================================================================="

do {
    $BuildImage = Read-Host -Prompt "Enter an option, or X to Exit"
}
until (
    (
        ($BuildImage -eq 'ENT') -or
        ($BuildImage -eq 'EDU') -or
        ($BuildImage -eq 'PRO') -or
        ($BuildImage -eq '1') -or
        ($BuildImage -eq '2') -or
        ($BuildImage -eq '3') -or
        ($BuildImage -eq '4') -or
        ($BuildImage -eq '5') -or
        ($BuildImage -eq '6') -or
        ($BuildImage -eq '7') -or
        ($BuildImage -eq 'X')
    ) 
)

Write-Host ""

if ($BuildImage -eq 'X') {
    Write-Host ""
    Write-TicTock; Write-Host "Adios!" -ForegroundColor Cyan
    Write-Host ""
    Break
}
#===================================================================================================
#   Define Build Process
#===================================================================================================
$BuildName              = 'OSDCloud'
$RequiresWinPE          = $true
#===================================================================================================
#   cURL
#===================================================================================================
if ($null -eq (Get-Command 'curl.exe' -ErrorAction SilentlyContinue)) { 
    Write-TicTock; Write-Host "cURL is required for this process to work"
    Start-Sleep -Seconds 10
    Break
}
#===================================================================================================
#   WinPE
#===================================================================================================
if ($RequiresWinPE) {
    if ((Get-OSDGather -Property IsWinPE) -eq $false) {
        Write-TicTock; Write-Warning "$BuildName can only be run from WinPE"
        Start-Sleep -Seconds 10
        Break
    }
}
#===================================================================================================
#   Remove USB Drives
#===================================================================================================
<# if (Get-USBDisk) {
    do {
        Write-TicTock; Write-Warning "Remove all attached USB Drives at this time ..."
        $RemoveUSB = $true
        pause
    }
    while (Get-USBDisk)
} #>
#===================================================================================================
Write-Host -ForegroundColor DarkCyan    "================================================================="
Write-TicTock
Write-Host -ForegroundColor Green       "Enabling High Performance Power Plan"
Write-Host -ForegroundColor Gray        "Get-OSDPower -Property High"
Get-OSDPower -Property High
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '1')) {
    Write-Host -ForegroundColor DarkCyan    "================================================================="
    Write-TicTock
    Write-Host -ForegroundColor Green       "Clearing Local Disks"
    Write-Host -ForegroundColor Gray        "Clear-LocalDisk -Force"
    Write-Warning "This computer will be prepared for Windows Build"
    Write-Warning "All Local Hard Drives will be wiped and all data will be lost"
    Write-Host ""
    Write-Warning "When you press any key to continue, this process will get started"
    pause
    Clear-LocalDisk -Force
}
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '2')) {
    Write-Host -ForegroundColor DarkCyan    "================================================================="
    Write-TicTock
    Write-Host -ForegroundColor Green       "Create New OSDisk"
    Write-Host -ForegroundColor Gray        "New-OSDisk -Force"
    New-OSDisk -Force
    Start-Sleep -Seconds 3
}
#===================================================================================================
if (-NOT (Get-PSDrive -Name 'C')) {
    Write-Warning "Disk does not seem to be ready.  Can't continue"
    Break
}
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '3')) {
    if ((Get-MyComputerManufacturer -Brief) -eq 'Dell') {
        Write-Host -ForegroundColor DarkCyan    "================================================================="
        Write-TicTock
        Write-Host -ForegroundColor Green       "Download and Update Dell BIOS (this is not working yet)"
        Write-Host -ForegroundColor Gray        "Update-MyDellBIOS"
        Update-MyDellBIOS

    }
}
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '4')) {
    Write-Host -ForegroundColor DarkCyan    "================================================================="
    Write-TicTock
    Write-Host -ForegroundColor Green       "Download Windows 10 ESD"
    Write-Host -ForegroundColor Gray        "Install-Module OSDSUS -Force"
    Write-Host -ForegroundColor Gray        "Import-Module OSDSUS -Force"
    Write-Host -ForegroundColor Gray        "Get-OSDSUS -Catalog FeatureUpdate"
    Write-Host -ForegroundColor Gray        "cURL Download"
    Install-Module OSDSUS -Force
    Import-Module OSDSUS -Force

    if (-NOT (Test-Path 'C:\OSDCloud\ESD')) {
        New-Item 'C:\OSDCloud\ESD' -ItemType Directory -Force -ErrorAction Stop | Out-Null
    }

    $WindowsESD = Get-OSDSUS -Catalog FeatureUpdate -UpdateArch x64 -UpdateBuild 2009 -UpdateOS "Windows 10" | Where-Object {$_.Title -match 'business'} | Where-Object {$_.Title -match 'en-us'} | Select-Object -First 1

    if (-NOT ($WindowsESD)) {
        Write-Warning "Could not find a Windows 10 download"
        Break
    }

    $Source = ($WindowsESD | Select-Object -ExpandProperty OriginUri).AbsoluteUri
    $OutFile = Join-Path 'C:\OSDCloud\ESD' $WindowsESD.FileName

    if (-NOT (Test-Path $OutFile)) {
        Write-Host "Downloading Windows 10 using cURL" -Foregroundcolor Cyan
        Write-Host "Source: $Source" -Foregroundcolor Cyan
        Write-Host "Destination: $OutFile" -Foregroundcolor Cyan
        #cmd /c curl.exe -o "$Destination" $Source
        & curl.exe --location --output "$OutFile" --url $Source
        #& curl.exe --location --output "$OutFile" --progress-bar --url $Source
    }

    if (-NOT (Test-Path $OutFile)) {
        Write-Warning "Something went wrong in the download"
        Break
    }
}
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '5')) {
    Write-Host -ForegroundColor DarkCyan    "================================================================="
    Write-TicTock
    Write-Host -ForegroundColor Green       "Expand Windows 10 ESD"
    Write-Host -ForegroundColor Gray        "Expand-WindowsImage"

    if (-NOT (Test-Path 'C:\OSDCloud\Temp')) {
        New-Item 'C:\OSDCloud\Temp' -ItemType Directory -Force | Out-Null
    }

    if ($BuildImage -eq 'EDU') {Expand-WindowsImage -ApplyPath 'C:\' -ImagePath "$OutFile" -Index 4 -ScratchDirectory 'C:\OSDCloud\Temp'}
    elseif ($BuildImage -eq 'PRO') {Expand-WindowsImage -ApplyPath 'C:\' -ImagePath "$OutFile" -Index 8 -ScratchDirectory 'C:\OSDCloud\Temp'}
    else {Expand-WindowsImage -ApplyPath 'C:\' -ImagePath "$OutFile" -Index 6 -ScratchDirectory 'C:\OSDCloud\Temp'}

    $SystemDrive = Get-Partition | Where-Object {$_.Type -eq 'System'} | Select-Object -First 1
    if (-NOT (Get-PSDrive -Name S)) {
        $SystemDrive | Set-Partition -NewDriveLetter 'S'
    }
    bcdboot C:\Windows /s S: /f ALL
    $SystemDrive | Remove-PartitionAccessPath -AccessPath "S:\"
}
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '6')) {
    if ((Get-MyComputerManufacturer -Brief) -eq 'Dell') {
        Write-Host -ForegroundColor DarkCyan    "================================================================="
        Write-TicTock
        Write-Host -ForegroundColor Green       "Download and Expand Dell Driver Cab"
        Write-Host -ForegroundColor Gray        "Save-MyDellDriverCab"
        Save-MyDellDriverCab
    }
}
#===================================================================================================
$PathAutoPilot = 'C:\Windows\Provisioning\AutoPilot'
if (-NOT (Test-Path $PathAutoPilot)) {
    New-Item -Path $PathAutoPilot -ItemType Directory -Force | Out-Null
}
$PathPanther = 'C:\Windows\Panther'
if (-NOT (Test-Path $PathPanther)) {
    New-Item -Path $PathPanther -ItemType Directory -Force | Out-Null
}
#===================================================================================================
$UnattendDrivers = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="offlineServicing">
        <component name="Microsoft-Windows-PnpCustomizationsNonWinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DriverPaths>
                <PathAndCredentials wcm:keyValue="1" wcm:action="add">
                    <Path>C:\Drivers</Path>
                </PathAndCredentials>
            </DriverPaths>
        </component>
    </settings>
</unattend>
'@
#===================================================================================================
Write-Host -ForegroundColor DarkCyan    "================================================================="
Write-TicTock
Write-Host -ForegroundColor Green       "Applying C:\Drivers using Unattend.xml"
Write-Host -ForegroundColor Gray        "Use-WindowsUnattend"

$UnattendPath = Join-Path $PathPanther 'Unattend.xml'
Write-Host -ForegroundColor Cyan "Setting Driver Unattend.xml at $UnattendPath"
$UnattendDrivers | Out-File -FilePath $UnattendPath -Encoding utf8

Write-Host -ForegroundColor Cyan "Applying Unattend ... this may take a while ..."
Use-WindowsUnattend -Path 'C:\' -UnattendPath $UnattendPath -Verbose
#===================================================================================================
Write-Host -ForegroundColor DarkCyan    "================================================================="
Write-TicTock
Write-Host -ForegroundColor Green       "OSDCloud is complete and can be rebooted at this time"