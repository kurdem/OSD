#===================================================================================================
#   Scripts/New-OSDisk.ps1
#===================================================================================================
Write-Host -ForegroundColor DarkCyan    "================================================================="
Write-Host -ForegroundColor White       "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))"
Write-Host -ForegroundColor Green       "Prepare OSDisk"
Clear-LocalDisk -Force -ShowWarning
New-OSDisk -Force
Start-Sleep -Seconds 3
if (-NOT (Get-PSDrive -Name 'C')) {
    Write-Warning "Disk does not seem to be ready.  Can't continue"
    Break
}