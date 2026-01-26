# 1. Get the operating system boot time and calculate uptime
$os = Get-CimInstance Win32_OperatingSystem
$uptime = (Get-Date) - $os.LastBootUpTime

# 2. Define the threshold (21 days)
$threshold = 21

# --- CRITICAL: This opening bracket '{' starts the main logic block ---
if ($uptime.Days -ge $threshold) {

    # --- GUI CREATION SECTION ---
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "System Reboot Required"
    $form.Size = New-Object System.Drawing.Size(420,240)
    $form.StartPosition = "CenterScreen"
    $form.TopMost = $true
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false

    # Icon
    $icon = New-Object System.Windows.Forms.PictureBox
    $icon.Size = New-Object System.Drawing.Size(48,48)
    $icon.Location = New-Object System.Drawing.Point(20,20)
    $icon.Image = [System.Drawing.SystemIcons]::Warning.ToBitmap()
    $form.Controls.Add($icon)

    # Label
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(80,20)
    $label.Size = New-Object System.Drawing.Size(300,100)
    $label.Text = "This system has been running for $($uptime.Days) days.`n`nPlease click Restart to begin a 120-second countdown, giving you time to save your final work."
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $form.Controls.Add($label)

    # --- BUTTONS ---

    # 'Restart' Button (Triggers 120s timer)
    $restartBtn = New-Object System.Windows.Forms.Button
    $restartBtn.Location = New-Object System.Drawing.Point(80,140)
    $restartBtn.Size = New-Object System.Drawing.Size(140,35)
    $restartBtn.Text = "Restart (120s Timer)"
    $restartBtn.BackColor = "LightCoral"
    
    $restartBtn.Add_Click({ 
        $form.Close()
        # Triggers standard Windows shutdown with /t 120 (seconds)
        Start-Process "shutdown.exe" -ArgumentList "/r /t 120 /c 'Uptime limit reached. Rebooting in 120 seconds. Please save your work.'"
        Write-Output "User clicked Restart. 120s countdown started."
    })
    $form.Controls.Add($restartBtn)

    # 'Cancel' Button
    $cancelBtn = New-Object System.Windows.Forms.Button
    $cancelBtn.Location = New-Object System.Drawing.Point(230,140)
    $cancelBtn.Size = New-Object System.Drawing.Size(120,35)
    $cancelBtn.Text = "Cancel"
    
    $cancelBtn.Add_Click({ 
        Write-Output "User clicked Cancel."
        $form.Close() 
    })
    $form.Controls.Add($cancelBtn)

    # --- SHOW WINDOW ---
    $form.ShowDialog() | Out-Null

} else {
    Write-Output "Uptime is $($uptime.Days) days. No notification needed."
}