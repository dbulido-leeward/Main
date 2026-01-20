# Get the operating system boot time
$os = Get-CimInstance Win32_OperatingSystem
$uptime = (Get-Date) - $os.LastBootUpTime

# Define the threshold (21 days)
$threshold = 21

if ($uptime.Days -ge $threshold) {
    $msgTitle = "Reboot Required"
    $msgText = "This system has been running for $($uptime.Days) days. Please save your work and reboot as soon as possible to ensure system stability."
    
    # Send a pop-up notification to all active sessions
    msg * /TIME:3600 "$msgText"
    
    Write-Output "Uptime is $($uptime.Days) days. Notification sent."
} else {
    Write-Output "Uptime is $($uptime.Days) days. No notification needed."
}