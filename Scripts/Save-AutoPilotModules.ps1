Write-Host -ForegroundColor White "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))"

Save-Module -Name WindowsAutoPilotIntune -Path 'C:\Program Files\WindowsPowerShell\Modules' -Verbose
if (-NOT (Test-Path 'C:\Program Files\WindowsPowerShell\Scripts')) {
    New-Item -Path 'C:\Program Files\WindowsPowerShell\Scripts' -ItemType Directory -Force | Out-Null
}
Save-Script -Name Get-WindowsAutoPilotInfo -Path 'C:\Program Files\WindowsPowerShell\Scripts' -Verbose