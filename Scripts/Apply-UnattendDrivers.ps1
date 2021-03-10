Write-Host -ForegroundColor White "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))"

$PathPanther = 'C:\Windows\Panther'
if (-NOT (Test-Path $PathPanther)) {
    New-Item -Path $PathPanther -ItemType Directory -Force | Out-Null
}

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

Write-Verbose -Verbose "Setting Driver $UnattendPath"
$UnattendPath = Join-Path $PathPanther 'Unattend.xml'
$UnattendDrivers | Out-File -FilePath $UnattendPath -Encoding utf8

Write-Verbose -Verbose "Applying Use-WindowsUnattend $UnattendPath"
Use-WindowsUnattend -Path 'C:\' -UnattendPath $UnattendPath -Verbose