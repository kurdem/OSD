#===================================================================================================
#   Scripts/Update-BIOS.ps1
#===================================================================================================
if ((Get-MyComputerManufacturer -Brief) -eq 'Dell') {
    Write-Host -ForegroundColor DarkCyan    "================================================================="
    Write-Host -ForegroundColor White       "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) " -NoNewline
    Write-Host -ForegroundColor Green       "Scripts/Update-BIOS.ps1"
    Write-Warning "This step is not working as expected ..."
    Update-MyDellBIOS
}