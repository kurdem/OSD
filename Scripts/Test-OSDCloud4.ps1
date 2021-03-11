$Global:StartOSDCloud = Get-Variable

$Global:GitHubUser = $GitHubUser
$Global:GitHubUserPath = "https://raw.githubusercontent.com/$Global:GitHubUser"

$Global:GitHubRepository = $Repository
$Global:GitHubRepositoryPath = "$Global:GitHubUserPath/$Global:GitHubRepository"

$Global:GitHubScript = $Script
$Global:GitHubScriptPath = "$Global:GitHubRepositoryPath/main/$Global:GitHubScript"

$Global:StartOSDCloudFullName = $Url

