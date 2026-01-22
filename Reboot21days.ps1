# Load the necessary Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 1. Get the operating system boot time
$os = Get-CimInstance Win32_OperatingSystem
$uptime = (Get-Date) - $os.LastBootUpTime

# 2. Define the threshold (21 days)
$threshold = 21

if ($uptime.Days -ge $threshold) {
    
    # Create the Form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Message from KF IT"
    $form.Size = New-Object System.Drawing.Size(400,200)
    $form.StartPosition = "CenterScreen"
    $form.Topmost = $true # Ensures it appears above other windows
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    # Create the Message Text
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Your device has been up for $($uptime.Days) days. Please save your work now and then press Restart. Alternatively, you can choose to do so later."
    $label.Location = New-Object System.Drawing.Point(20,20)
    $label.Size = New-Object System.Drawing.Size(350,60)
    $form.Controls.Add($label)

    # Create "Restart Now" Button
    $restartBtn = New-Object System.Windows.Forms.Button
    $restartBtn.Text = "Restart Now"
    $restartBtn.Location = New-Object System.Drawing.Point(80,100)
    $restartBtn.Size = New-Object System.Drawing.Size(100,30)
    $restartBtn.Add_Click({
        # Command to restart the computer immediately
        Restart-Computer -Force
    })
    $form.Controls.Add($restartBtn)

    # Create "Later" Button
    $laterBtn = New-Object System.Windows.Forms.Button
    $laterBtn.Text = "Later"
    $laterBtn.Location = New-Object System.Drawing.Point(200,100)
    $laterBtn.Size = New-Object System.Drawing.Size(100,30)
    $laterBtn.Add_Click({ $form.Close() })
    $form.Controls.Add($laterBtn)

    # Display the window
    $form.ShowDialog() | Out-Null

} else {
    Write-Output "Uptime is $($uptime.Days) days. No notification needed."
}
