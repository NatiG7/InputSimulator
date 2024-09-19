# Define the file path to save mouse positions and the attempt number
$positionsFilePath = "MousePositions.txt"
$attemptNumberFilePath = "AttemptNumber.txt"

# Initialize or clear the positions file
if (-not (Test-Path $positionsFilePath)) {
    Add-Content -Path $positionsFilePath -Value "Mouse Positions Log:`n" -Force
}

# Read the current attempt number from file or initialize to 0
if (Test-Path $attemptNumberFilePath) {
    $lastLine = (Get-Content $attemptNumberFilePath | Select-Object -Last 1)
    if ($lastLine -match "Attempt Number : (\d+)") {
        $global:attemptNumber = [int]$matches[1]
    }
    else {
        $global:attemptNumber = 0
    }
}
else {
    $global:attemptNumber = 0
}

# Increment attempt number
$global:attemptNumber++


# Start logging attempt in the positions file
Add-Content -Path $positionsFilePath -Value "`nAttempt Number : $attemptNumber`n"

# Function to generate a unique ID
function New-UniqueId {
    [guid]::NewGuid().ToString()
}

# Function to write mouse position to file with additional information
function Write-MousePosition {
    param (
        [string]$filePath,
        [int]$attemptNumber,
        [int]$clickNumber
    )
    $name = Show-InputDialog "Enter a name for click $clickNumber" "Name Your Click"
    
    if (-not $name) {
        $name = $clickNumber
        continue
    }

    $point = [MouseMapper]::GetMousePosition()  # Assuming this function gets the current mouse position
    $uniqueId = New-UniqueId
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $position = "Click number $clickNumber : $uniqueId, $timestamp, X=$($point.X), Y=$($point.Y)"
    $namedPosition = "`$$name = (X=$($point.X), Y=$($point.Y))"
    Add-Content -Path $filePath -Value "$position`n$namedPosition`n"
    Set-Variable -Name $name -Value "X=$($point.X), Y=$($point.Y)"
    Add-Content -Path $filePath -Value $position
    Write-Host "Position recorded: Attempt $attemptNumber, Click $clickNumber, ID $uniqueId, Date $timestamp, Named Position : $namedPosition"
}

# Function to show a tooltip message
function Show-Tooltip {
    param (
        [string]$message,
        [int]$durationSeconds = 5
    )
    $form = New-Object System.Windows.Forms.Form
    $label = New-Object System.Windows.Forms.Label
    $form.Text = "Mouse Position Mapper"
    $form.Size = New-Object System.Drawing.Size(300, 100)
    $form.StartPosition = "CenterScreen"
    $label.Text = $message
    $label.AutoSize = $true
    $label.Dock = "Fill"
    $label.TextAlign = "MiddleCenter"
    $form.Controls.Add($label)
    $form.TopMost = $true
    # Timer for the form
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = $durationSeconds * 1000 # Milliseconds
    $timer.Add_Tick({
            $form.Close()
            $timer.Stop()
        })
    $form.Show()
    $form.Close()
}

# Function to show an input dialog to prompt for the click name
function Show-InputDialog {
    param (
        [string]$text,   # Text to display in the dialog
        [string]$caption # Title of the dialog window
    )

    # Create the input box
    $inputBox = New-Object System.Windows.Forms.Form
    $inputBox.Text = $caption
    $inputBox.Size = New-Object System.Drawing.Size(300, 150)
    $inputBox.StartPosition = "CenterScreen"

    # Create a label to display the prompt text
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $text
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $inputBox.Controls.Add($label)

    # Create a textbox to enter the input
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $textBox.Location = New-Object System.Drawing.Point(10, 40)
    $inputBox.Controls.Add($textBox)

    # Create an OK button to submit the input
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(10, 70)
    $okButton.Add_Click({
        $inputBox.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $inputBox.Close()
    })
    # Create a Cancel button to close the input dialog without saving
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Location = New-Object System.Drawing.Point(90, 70)  # Adjusted position to avoid overlap
    $cancelButton.Add_Click({
        $inputBox.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $inputBox.Close()
    })
    $inputBox.Controls.Add($okButton)
    $inputBox.Controls.Add($cancelButton)

    # Display the dialog and get the input if OK is clicked
    if ($inputBox.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $textBox.Text
    } elseif ($inputBox.ShowDialog() -eq [System.Windows.Forms.DialogResult]::Cancel) {
        exit
    }
    else {
        return $null
    }
}