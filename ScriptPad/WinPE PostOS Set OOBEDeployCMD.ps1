#================================================
#   WinPE PostOS
#   Set OOBEDeployCMD
#================================================
$SetCommand = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
start PowerShell -NoL -W Mi
start "Install-Module OSD" /wait PowerShell -NoL -C Write-Host 'Install-Module OSD';Install-Module OSD -Force -Verbose
start "Start-OOBEDeploy" PowerShell -NoL -C Start-OOBEDeploy
exit
'@
$SetCommand | Out-File -FilePath "C:\Windows\OOBEDeploy.cmd" -Encoding ascii -Force