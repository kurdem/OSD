#===================================================================================================
#   Start-OSDCloud
#===================================================================================================
$GitHubRepo = 'https://github.com/OSDeploy/OSDCloud/blob/main'
$GitHubScript = 'Start-OSDCloud.ps1'
Write-Host "Starting $GitHubRepo/$GitHubScript" -Foregroundcolor Cyan
Write-Host ""
#===================================================================================================
#   OSDCloud Options
#===================================================================================================
Write-Host "FOR TESTING ONLY, NON-PRODUCTION"
Write-Host -ForegroundColor DarkCyan "================================================================="

Write-Host "AUTO" -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Automated Everything"

Write-Host "   1" -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Clear-LocalDisk"

Write-Host "   2" -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    New-OSDisk"

Write-Host "   3" -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Install-Module OSDSUS"

Write-Host "   4" -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Download Windows 10 20H2 x64"

Write-Host "   X" -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "    Exit"

Write-Host ""

do {
    $BuildImage = Read-Host -Prompt "Enter an option, or X to Exit"
}
until (
    (
        ($BuildImage -eq 'AUTO') -or
        ($BuildImage -eq '1') -or
        ($BuildImage -eq '2') -or
        ($BuildImage -eq '3') -or
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
#===================================================================================================
#   Define Build Process
#===================================================================================================
$BuildName              = 'Default'
$RequiresWinPE          = $true
#===================================================================================================
#   Enable High Performance Power Plan
#===================================================================================================
Get-OSDPower -Property High
#===================================================================================================
#   Verify WinPE
#===================================================================================================
if ($RequiresWinPE) {
    if ((Get-OSDGather -Property IsWinPE) -eq $false) {
        Write-Warning "$BuildName can only be run from WinPE"
        pause
        Break
    }
}
#===================================================================================================
#   Remove USB Drives
#===================================================================================================
if (Get-USBDisk) {
    do {
        Write-Warning "Remove all attached USB Drives at this time ..."
        $RemoveUSB = $true
        pause
    }
    while (Get-USBDisk)
}
#===================================================================================================
#   Clear Local Disks
#===================================================================================================
if (($BuildImage -eq 'AUTO') -or ($BuildImage -eq '1')) {
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
if (($BuildImage -eq 'AUTO') -or ($BuildImage -eq '2')) {
    New-OSDisk -Force
    Start-Sleep -Seconds 3
}
#===================================================================================================
#   Install OSDSUS
#===================================================================================================
if (($BuildImage -eq 'AUTO') -or ($BuildImage -eq '3')) {
    Install-Module OSDSUS -Force
    Import-Module OSDSUS -Force
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
<# $PathAutoPilot = 'C:\Windows\Provisioning\AutoPilot'
if (-NOT (Test-Path $PathAutoPilot)) {
    Write-Warning "An error has occurred finding $PathAutoPilot"
    Write-Warning "AutoPilot will exit"
    Break
}
$PathPanther = 'C:\Windows\Panther'
if (-NOT (Test-Path $PathPanther)) {
    New-Item -Path $PathPanther -ItemType Directory -Force | Out-Null
}

$AutoPilotConfigurationFile = Join-Path $PathAutoPilot 'AutoPilotConfigurationFile.json'
$UnattendPath = Join-Path $PathPanther 'Unattend.xml' #>
#===================================================================================================
#   Apply AutoPilot
#===================================================================================================
<# if ($AutoPilotProd -or $AutoPilotDev) {
    Write-Verbose -Verbose "Setting $AutoPilotConfigurationFile"
    if ($AutoPilotProd) {
        $AutoPilotJsonProd | Out-File -FilePath $AutoPilotConfigurationFile -Encoding ASCII
    }
    if ($AutoPilotDev) {
        $AutoPilotJsonDev | Out-File -FilePath $AutoPilotConfigurationFile -Encoding ASCII
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
$UnattendAuditModeAutoPilot = @'
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
                    <Description>Configure AutoPilot</Description>
                    <Path>PowerShell.exe -WindowStyle Minimized -File "C:\Program Files\WindowsPowerShell\Scripts\Upload-WindowsAutopilotDeviceInfo.ps1" -TenantName "bakerhughes.onmicrosoft.com" -GroupTag Enterprise</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>3</Order>
                    <Description>AutoPilot Sync Delay</Description>
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
    Write-Verbose -Verbose "Setting AutoPilot Unattend.xml at $UnattendPath"
    $UnattendAuditModeAutoPilot | Out-File -FilePath $UnattendPath -Encoding utf8
    Write-Verbose -Verbose "Applying Unattend"
    Use-WindowsUnattend -Path 'C:\' -UnattendPath $UnattendPath -Verbose
} #>
<# Write-Verbose -Verbose "This computer will restart in 30 seconds"
Start-Sleep -Seconds 30
Get-OSDWinPE -Reboot
Start-Sleep -Seconds 10
Exit 0 #>