# Define the SSH config file path
$sshConfigPath = "$HOME\.ssh\config"

# Ensure the .ssh directory exists
if (-not (Test-Path "$HOME\.ssh")) {
    New-Item -ItemType Directory -Path "$HOME\.ssh" | Out-Null
}

# Prompt for the GitHub username
$githubUsername = Read-Host -Prompt "Enter your GitHub username"

# Check if the configuration block already exists
$configExists = Select-String -Path $sshConfigPath -Pattern "Host github.com" -Quiet

if (-not $configExists) {
    # Create the configuration block with the entered username
    $configBlock = @"
Host github.com
    User $githubUsername
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519_github
"@

    # Append the configuration block to the config file
    $configBlock | Out-File -FilePath $sshConfigPath -Encoding UTF8 -Append

    Write-Host "Configuration added to $sshConfigPath."
} else {
    Write-Host "Configuration already exists in $sshConfigPath."
}

# Ensure the config file has the correct permissions (optional, recommended)
icacls $sshConfigPath /inheritance:r /grant:r "$($env:USERNAME):F" | Out-Null
icacls "$HOME\.ssh" /inheritance:r /grant:r "$($env:USERNAME):F" | Out-Null

Write-Host "Done."