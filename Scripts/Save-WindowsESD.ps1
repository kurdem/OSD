#===================================================================================================
#   Scripts/Save-WindowsESD.ps1
#===================================================================================================
Write-Host -ForegroundColor DarkCyan    "================================================================="
Write-Host -ForegroundColor White       "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) " -NoNewline
Write-Host -ForegroundColor Green       "Scripts/Save-WindowsESD.ps1"
Install-Module OSDSUS -Force
Import-Module OSDSUS -Force

if (-NOT ($Global:OSCulture)) {
    $Global:OSCulture = 'en-us'
}

if (-NOT (Test-Path 'C:\OSDCloud\ESD')) {
    New-Item 'C:\OSDCloud\ESD' -ItemType Directory -Force -ErrorAction Stop | Out-Null
}

$WindowsESD = Get-OSDSUS -Catalog FeatureUpdate -UpdateArch x64 -UpdateBuild 2009 -UpdateOS "Windows 10" | Where-Object {$_.Title -match 'business'} | Where-Object {$_.Title -match $Global:OSCulture} | Select-Object -First 1

if (-NOT ($WindowsESD)) {
    Write-Warning "Could not find a Windows 10 download"
    Break
}

$Source = ($WindowsESD | Select-Object -ExpandProperty OriginUri).AbsoluteUri
$OutFile = Join-Path 'C:\OSDCloud\ESD' $WindowsESD.FileName

if (-NOT (Test-Path $OutFile)) {
    Write-Host "Downloading Windows 10 using cURL" -Foregroundcolor Cyan
    Write-Host "Source: $Source" -Foregroundcolor Cyan
    Write-Host "Destination: $OutFile" -Foregroundcolor Cyan
    Write-Host "OSCulture: $Global:OSCulture" -Foregroundcolor Cyan
    #cmd /c curl.exe -o "$Destination" $Source
    & curl.exe --location --output "$OutFile" --url $Source
    #& curl.exe --location --output "$OutFile" --progress-bar --url $Source
}

if (-NOT (Test-Path $OutFile)) {
    Write-Warning "Something went wrong in the download"
    Break
}