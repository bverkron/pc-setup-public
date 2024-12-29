param (
    [string]$Mac,
    [string]$Hostname,
    [int]$TimeoutSeconds = 30
)

if (-not $Mac) {
    Write-Error "Error: Missing MAC address. Please provide a valid MAC address as a parameter." -ForegroundColor Red
    exit 1
}

if (-not $Hostname) {
    Write-Error "Error: Missing Hostname/IP address. Please provide the Hostname/IP address of the remote machine." -ForegroundColor Red
    exit 1
}

try {
    # Validate MAC address format
    if ($Mac -notmatch '^[0-9A-Fa-f]{2}([-:])(?:[0-9A-Fa-f]{2}\1){4}[0-9A-Fa-f]{2}$') {
        throw "Invalid MAC address format. Please provide a valid MAC address."
    }

    # Convert MAC address to byte array
    $MacByteArray = $Mac -split "[:-]" | ForEach-Object { [Byte] "0x$_" }
    [Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray * 16)

    # Send the Magic Packet
    $UdpClient = New-Object System.Net.Sockets.UdpClient
    $UdpClient.Connect(([System.Net.IPAddress]::Broadcast), 7)
    $UdpClient.Send($MagicPacket, $MagicPacket.Length)
    $UdpClient.Close()

    Write-Output "Magic Packet sent successfully to $Mac." -ForegroundColor Blue

    # Wait for the remote machine to respond
    Write-Output "Waiting for the remote machine ($Hostname) to respond..." -ForegroundColor Blue
    $StartTime = Get-Date
    $Timeout = $StartTime.AddSeconds($TimeoutSeconds)
    $MachineResponded = $false

    while (-not $MachineResponded -and (Get-Date) -lt $Timeout) {
        if (Test-Connection -ComputerName $Hostname -Count 1 -Quiet) {
            $MachineResponded = $true
            Write-Output "The remote machine ($Hostname) is now responding." -ForegroundColor Green
        } else {
            Start-Sleep -Seconds 5
        }
    }

    if (-not $MachineResponded) {
        Write-Error "Error: The remote machine ($Hostname) did not respond within the timeout period of $TimeoutSeconds seconds." -ForegroundColor Red
        exit 2
    }
} catch {
    Write-Error "Error: $_" -ForegroundColor Red
}