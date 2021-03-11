#===================================================================================================
#   Scripts/Update-BIOS.ps1
#===================================================================================================
if ((Get-MyComputerManufacturer -Brief) -eq 'Dell') {
    Write-Host -ForegroundColor DarkCyan    "================================================================="
    Write-Host -ForegroundColor White       "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))"
    Write-Host -ForegroundColor Green       "BIOS Update"
    Update-MyDellBIOS
}