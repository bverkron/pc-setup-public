$ScriptName = "wol.ps1"
$SourceScript = "https://raw.githubusercontent.com/bverkron/pc-setup-public/refs/heads/main/Network/$ScriptName"
$DestinationPath = "C:\Storage\scripts\Network\"
$DestinationScript = "$DestinationPath\$ScriptName"

if (-not (Test-Path -Path "$DestinationPath")) {
    New-Item -ItemType Directory -Path "$DestinationPath"
} else {
    Write-Host "Directory already exists: $DestinationPath" -ForegroundColor Blue
}

# Download the script
Write-Host "Downloading script from $SourceScript..." -ForegroundColor Blue
Invoke-WebRequest -Uri $SourceScript -OutFile "$DestinationScript" -UseBasicParsing

# Check if the script was downloaded successfully
if (Test-Path $DestinationScript) {
    Write-Host "Script downloaded successfully. Setting permissions..." -ForegroundColor Blue

    # Unblock the file to prevent execution policy restrictions
    Unblock-File -Path $DestinationScript
    
    Write-Host "Permissions set" -ForegroundColor Green


} else {
    Write-Error "Failed to download the script. Please check the URL or your internet connection." -ForegroundColor Red
}