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
    $point = [MouseMapper]::GetMousePosition()  # Assuming this function gets the current mouse position
    $uniqueId = New-UniqueId
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $position = "Click number $clickNumber : $uniqueId, $timestamp, X=$($point.X), Y=$($point.Y)"
    Add-Content -Path $filePath -Value $position
    Write-Host "Position recorded: Attempt $attemptNumber, Click $clickNumber, ID $uniqueId, Date $timestamp"
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
