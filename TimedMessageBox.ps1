function Show-TimedMessageBox {
    param (
        [string]$Message,
        [int]$DurationSeconds
    )

    # Create a new form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Notification"
    $form.Size = New-Object System.Drawing.Size(300, 100)
    $form.StartPosition = "CenterScreen"
    
    # Create a label to display the message
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Message
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $form.Controls.Add($label)
    
    # Create a timer to close the form after the specified duration
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = $DurationSeconds * 1000 # Convert seconds to milliseconds
    $timer.Add_Tick({
            $form.Close()
            $timer.Stop()
        })
    
    # Start the timer
    $timer.Start()
    
    # Show the form
    $form.Show()
}

Show-TimedMessageBox -Message "Hello" -DurationSeconds 3