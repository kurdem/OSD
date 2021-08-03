#================================================
#   PostOS
#   OOBEDeploy CMD File
#================================================
$OOBEDeployCMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
start PowerShell -NoL -W Mi
start /wait PowerShell -NoL -C Install-Module OSD -Force
start /wait PowerShell -NoL -C Start-OOBEDeploy
exit
'@
$OOBEDeployCMD | Out-File -FilePath "C:\Windows\OOBEDeploy.cmd" -Encoding ascii -Force