# Path to the known_hosts file
$knownHostsPath = "$HOME\.ssh\known_hosts"

# Ensure the file exists
if (-Not (Test-Path -Path $knownHostsPath)) {
    Write-Host "The file '$knownHostsPath' does not exist." -ForegroundColor Yellow
    return
}

# Get the current user's identity
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Remove all existing permissions from the file
icacls $knownHostsPath /inheritance:r
icacls $knownHostsPath /remove:g "Everyone" "Users" "Authenticated Users" "Administrators"

# Grant the current user full control
icacls $knownHostsPath /grant "${currentUser}:(F)"

# Verify the permissions
Write-Host "Updated permissions for '$knownHostsPath':"
icacls $knownHostsPath