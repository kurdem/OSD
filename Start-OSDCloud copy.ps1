$SourceGist = 'https://gist.github.com/OSDeploy/95fddd8bb5d567b5405b2d38ee376bac'
$SourceGistRAW = 'https://gist.githubusercontent.com/OSDeploy/95fddd8bb5d567b5405b2d38ee376bac/raw/Deploy-OSDCloud.ps1'

Write-Host "Deploy-OSDCloud.ps1" -Foregroundcolor Cyan
Write-Host "This PowerShell Script is executing from a GitHub Gist" -Foregroundcolor Cyan
Write-Host "$SourceGist"
Write-Host "$SourceGistRAW"
Write-Host ""
#===================================================================================================
#   Require WinPE
#===================================================================================================
if ($RequiresWinPE) {
    if ((Get-OSDGather -Property IsWinPE) -eq $false) {
        Write-Warning "$BuildName can only be run from WinPE"
        pause
        Break
    }
}
#===================================================================================================
#   Require UEFI
#===================================================================================================
if ($RequiresUEFI) {
    if ((Get-OSDGather -Property IsUEFI) -eq $false) {
        Write-Warning "$BuildName requires UEFI"
        pause
        Break
    }
}
#===================================================================================================
#   Enable High Performance Power Plan
#===================================================================================================
Get-OSDPower -Property High
#===================================================================================================
#   Warning
#===================================================================================================
Write-Warning "This computer will be prepared for Windows Build"
Write-Warning "All Local Hard Drives will be wiped and all data will be lost"
Write-Host ""
Write-Warning "When you press any key to continue, this process will get started"
pause
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
Clear-LocalDisk -Force
#===================================================================================================
#   Create OSDisk
#===================================================================================================
New-OSDisk -Force
Start-Sleep -Seconds 3
#===================================================================================================
#   Dell BIOS Update
#===================================================================================================
if ((Get-MyComputerManufacturer -Brief) -eq 'Dell') {
    Update-MyDellBIOS
}

Install-Module OSDSUS -Force
Import-Module OSDSUS -Force
Write-Verbose "Finding ISO with OSDSUS" -Verbose
$Win10ISO = Get-OSDSUS -Catalog FeatureUpdate -UpdateArch x64 -UpdateBuild 2009 -UpdateOS "Windows 10" | ? Title -match 'business' | ? Title -match 'en-us' | Select -First 1
$Source = ($Win10ISO | Select -ExpandProperty OriginUri).AbsoluteUri
$Destination = Join-Path 'C:\' $Win10ISO.FileName

Write-Host "Downloading Windows 10 using cURL from $Source" -Foregroundcolor Cyan
cmd /c curl -o "$Destination" $Source



Write-Host "GitHub Gist Script Complete" -Foregroundcolor Cyan
Pause