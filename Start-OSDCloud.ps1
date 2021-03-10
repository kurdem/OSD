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
Write-Host ""
#===================================================================================================
#   OSDCloud Options
#===================================================================================================
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
Write-Host "    Install-Module OSDSUS"

Write-Host "5   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Download and Apply Windows 10 20H2 x64"

Write-Host "6   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Dell - Download, Expand, and Apply Driver Cab"

Write-Host "X   " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Exit"

Write-Host ""

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
   pause
   Break
}
#===================================================================================================
#   WinPE
#===================================================================================================
if ($RequiresWinPE) {
    if ((Get-OSDGather -Property IsWinPE) -eq $false) {
        Write-TicTock; Write-Warning "$BuildName can only be run from WinPE"
        pause
        Break
    }
}
#===================================================================================================
#   Remove USB Drives
#===================================================================================================
if (Get-USBDisk) {
    do {
        Write-TicTock; Write-Warning "Remove all attached USB Drives at this time ..."
        $RemoveUSB = $true
        pause
    }
    while (Get-USBDisk)
}
#===================================================================================================
#   Enable High Performance Power Plan
#===================================================================================================
Get-OSDPower -Property High
#===================================================================================================
#   Clear Local Disks
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '1')) {
    Write-Warning "This computer will be prepared for Windows Build"
    Write-Warning "All Local Hard Drives will be wiped and all data will be lost"
    Write-Host ""
    Write-Warning "When you press any key to continue, this process will get started"
    pause
    Clear-LocalDisk -Force
}
#===================================================================================================
#   Create OSDisk
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '2')) {
    New-OSDisk -Force
    Start-Sleep -Seconds 3
}

if (-NOT (Get-PSDrive -Name 'C')) {
    Write-Warning "Disk does not seem to be ready.  Can't continue"
    Break
}
#===================================================================================================
#   Update-MyDellBIOS
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '3')) {
    Update-MyDellBIOS
}
#===================================================================================================
#   Install OSDSUS
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '4')) {
    Install-Module OSDSUS -Force
    Import-Module OSDSUS -Force
}
#===================================================================================================
#   Download Windows 10
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '5')) {

    if (-NOT (Test-Path 'C:\OSDCloud\ESD')) {
        New-Item 'C:\OSDCloud\ESD' -ItemType Directory -Force -ErrorAction Stop | Out-Null
    }
    
    if (-NOT (Test-Path $OutFile)) {

        Write-Verbose "Finding Windows 10 downloads with OSDSUS" -Verbose
        $WindowsESD = Get-OSDSUS -Catalog FeatureUpdate -UpdateArch x64 -UpdateBuild 2009 -UpdateOS "Windows 10" | Where-Object {$_.Title -match 'business'} | Where-Object {$_.Title -match 'en-us'} | Select-Object -First 1

        if ($WindowsESD) {
            $Source = ($WindowsESD | Select-Object -ExpandProperty OriginUri).AbsoluteUri
            $OutFile = Join-Path 'C:\OSDCloud\ESD' $WindowsESD.FileName

            Write-Host "Downloading Windows 10 using cURL from $Source" -Foregroundcolor Cyan
            #cmd /c curl.exe -o "$Destination" $Source
            & curl.exe --location --output "$OutFile" --url $Source
            #& curl.exe --location --output "$OutFile" --progress-bar --url $Source
        } else {
            Write-Warning "Could not find a Windows 10 download"
            Break
        }
    }

    if (-NOT (Test-Path $OutFile)) {
        Write-Warning "Something went wrong in the download"
        Break
    }

    if ($BuildImage -eq 'ENT') {Expand-WindowsImage -ApplyPath 'C:\' -ImagePath "$OutFile" -Index 6}
    if ($BuildImage -eq 'EDU') {Expand-WindowsImage -ApplyPath 'C:\' -ImagePath "$OutFile" -Index 4}
    if ($BuildImage -eq 'PRO') {Expand-WindowsImage -ApplyPath 'C:\' -ImagePath "$OutFile" -Index 8}

    if (-NOT (Get-PSDrive -Name S)) {
        
    }
}
#===================================================================================================
#   Download Drivers
#===================================================================================================
if (($BuildImage -eq 'ENT') -or ($BuildImage -eq 'EDU') -or ($BuildImage -eq 'PRO') -or ($BuildImage -eq '6')) {
    Save-MyDellDriverCab
}
#===================================================================================================
#   Apply OS
#===================================================================================================
<# try {Expand-WindowsImage -ImagePath $OperatingSystem -ApplyPath "C:\" -Index 1 -ErrorAction Ignore}
catch {Write-Host "Writing Image"} #>

#dism /apply-image /imagefile:"$OperatingSystem\OS\Sources\install.swm" /SWMFile:"$OperatingSystem\OS\Sources\install*.swm" /index:1 /applydir:c:\

<# $SystemDrive = Get-Partition | Where-Object {$_.Type -eq 'System'} | Select-Object -First 1
$SystemDrive | Set-Partition -NewDriveLetter 'S' #>
#bcdboot C:\Windows /s S: /f ALL
#$SystemDrive | Remove-PartitionAccessPath -AccessPath "S:\"
#===================================================================================================
#   Create Directories
#===================================================================================================
<# $PathENTPilot = 'C:\Windows\Provisioning\ENTPilot'
if (-NOT (Test-Path $PathENTPilot)) {
    Write-Warning "An error has occurred finding $PathENTPilot"
    Write-Warning "ENTPilot will exit"
    Break
}
$PathPanther = 'C:\Windows\Panther'
if (-NOT (Test-Path $PathPanther)) {
    New-Item -Path $PathPanther -ItemType Directory -Force | Out-Null
}

$ENTPilotConfigurationFile = Join-Path $PathENTPilot 'ENTPilotConfigurationFile.json'
$UnattendPath = Join-Path $PathPanther 'Unattend.xml' #>
#===================================================================================================
#   Apply ENTPilot
#===================================================================================================
<# if ($ENTPilotProd -or $ENTPilotDev) {
    Write-Verbose -Verbose "Setting $ENTPilotConfigurationFile"
    if ($ENTPilotProd) {
        $ENTPilotJsonProd | Out-File -FilePath $ENTPilotConfigurationFile -Encoding ASCII
    }
    if ($ENTPilotDev) {
        $ENTPilotJsonDev | Out-File -FilePath $ENTPilotConfigurationFile -Encoding ASCII
    }
} #>
#===================================================================================================
#   Apply Drivers
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
<# if ($ApplyDrivers) {
    & $Drivers\Deploy-OSDDrivers.ps1
    Write-Verbose -Verbose "Copying Drivers ... this may take a while ..."
    
    Write-Verbose -Verbose "Setting Driver Unattend.xml at $UnattendPath"
    $UnattendDrivers | Out-File -FilePath $UnattendPath -Encoding utf8

    Write-Verbose -Verbose "Applying Unattend ... this may take a while ..."
    Use-WindowsUnattend -Path 'C:\' -UnattendPath $UnattendPath -Verbose
} #>
#===================================================================================================
#   Apply ApplyUnattendAE
#===================================================================================================
$UnattendAuditModeENTPilot = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <Reseal>
                <Mode>Audit</Mode>
            </Reseal>
        </component>
    </settings>
    <settings pass="auditUser">
        <component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <RunSynchronous>
                <RunSynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Description>Set ExecutionPolicy Bypass</Description>
                    <Path>PowerShell -WindowStyle Hidden -Command "Set-ExecutionPolicy Bypass -Force"</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <Description>Configure ENTPilot</Description>
                    <Path>PowerShell.exe -WindowStyle Minimized -File "C:\Program Files\WindowsPowerShell\Scripts\Upload-WindowsENTpilotDeviceInfo.ps1" -TenantName "bakerhughes.onmicrosoft.com" -GroupTag Enterprise</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>3</Order>
                    <Description>ENTPilot Sync Delay</Description>
                    <Path>PowerShell.exe -WindowStyle Minimized -Command Write-Host "Please wait up to 10 minutes ...";Start-Sleep -Seconds 600</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>4</Order>
                    <Description>Set ExecutionPolicy RemoteSigned</Description>
                    <Path>PowerShell -WindowStyle Hidden -Command "Set-ExecutionPolicy RemoteSigned -Force"</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>5</Order>
                    <Description>Sysprep OOBE Reboot</Description>
                    <Path>%SystemRoot%\System32\Sysprep\Sysprep.exe /OOBE /Reboot</Path>
                </RunSynchronousCommand>
            </RunSynchronous>
        </component>
    </settings>
</unattend>
'@
<# if ($ApplyUnattendAE) {
    Write-Verbose -Verbose "Setting ENTPilot Unattend.xml at $UnattendPath"
    $UnattendAuditModeENTPilot | Out-File -FilePath $UnattendPath -Encoding utf8
    Write-Verbose -Verbose "Applying Unattend"
    Use-WindowsUnattend -Path 'C:\' -UnattendPath $UnattendPath -Verbose
} #>
<# Write-Verbose -Verbose "This computer will restart in 30 seconds"
Start-Sleep -Seconds 30
Get-OSDWinPE -Reboot
Start-Sleep -Seconds 10
Exit 0 #>