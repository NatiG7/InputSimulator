# Define the file path to save mouse positions and the attempt number
$positionsFilePath = "MousePositions.txt"
$attemptNumberFilePath = "AttemptNumber.txt"

# Initialize or clear the positions file
Add-Content -Path $positionsFilePath -Value "Mouse Positions Log:`n" -Force

# Read the current attempt number from file or initialize to 0
if (Test-Path $attemptNumberFilePath) {
    $attemptNumber = [int](Get-Content $attemptNumberFilePath)
} else {
    $attemptNumber = 0
}

# Function to generate a unique ID
function New-UniqueId {
    [guid]::NewGuid().ToString()
}

# Function to write mouse position to file with additional information
function Write-MousePosition {
    param (
        [string]$filePath,
        [int]$attemptNumber
    )
    $point = [MouseMapper]::GetMousePosition()
    $uniqueId = New-UniqueId
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $position = "Attempt ${attemptNumber}:`nDate: $timestamp`nUnique ID: $uniqueId`nPosition: X=$($point.X), Y=$($point.Y)`n"
    Add-Content -Path $filePath -Value $position
    Write-Host "Position recorded: Attempt $attemptNumber, ID $uniqueId, Date $timestamp"
}

# Function to show a tooltip message
function Show-Tooltip {
    param (
        [string]$message
    )
    $form = New-Object System.Windows.Forms.Form
    $label = New-Object System.Windows.Forms.Label
    $form.Text = "Mouse Position Mapper"
    $form.Size = New-Object System.Drawing.Size(300,100)
    $form.StartPosition = "CenterScreen"
    $label.Text = $message
    $label.AutoSize = $true
    $label.Dock = "Fill"
    $label.TextAlign = "MiddleCenter"
    $form.Controls.Add($label)
    $form.TopMost = $true
    $form.Show()
    Start-Sleep -Seconds 5
    $form.Close()
}
