# Function to flash the mouse cursor
function FlashMouseCursor {
    param (
        [int]$flashCount = 5,         # Number of times the cursor flashes
        [int]$flashDuration = 100     # Duration of each flash in milliseconds
    )

    # Get current mouse position
    $currentPosition = [InputSimulator]::GetMousePosition()

    # Flash the cursor by moving it slightly and returning to the original position
    for ($i = 0; $i -lt $flashCount; $i++) {
        # Move cursor slightly to the right and down
        [InputSimulator]::SetMousePosition($currentPosition.X + 10, $currentPosition.Y + 10)
        Start-Sleep -Milliseconds $flashDuration

        # Return cursor to original position
        [InputSimulator]::SetMousePosition($currentPosition.X, $currentPosition.Y)
        Start-Sleep -Milliseconds $flashDuration
    }

    # Ensure the cursor is back at the original position after flashing
    [InputSimulator]::SetMousePosition($currentPosition.X, $currentPosition.Y)
}

# Function to simulate typing each character in a string
function TypeString {
    param (
        [string]$text
    )
    foreach ($char in $text.ToCharArray()) {
        $asciiValue = [byte][char]$char  # Get ASCII value of the character
        [InputSimulator]::PressKey($asciiValue)  # Simulate key press for the character
    }
}

# Function to display a Yes/No dialog with an Exit option
function Show-YesNoDialog {
    param (
        [string]$message
    )

    $result = [System.Windows.Forms.MessageBox]::Show($message, "Confirmation", [System.Windows.Forms.MessageBoxButtons]::YesNoCancel)
    return $result
}

# Function to handle the logic of each step
function ExecuteStep {
    param (
        [ScriptBlock]$stepLogic,  # The logic to execute for this step
        [string]$description,     # Description of the step
        [int]$stepNumber          # Step number
    )

    $repeatStep = $true

    while ($repeatStep) {
        Write-Host "Executing Step ${stepNumber}: $description"

        # Execute the logic for the step
        & $stepLogic

        # Show the dialog to confirm next step, repeat, or exit
        $result = Show-YesNoDialog "Continue to next step? (Yes: Continue, No: Repeat, Cancel: Exit)"

        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            $repeatStep = $false  # Move to the next step
        } elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
            Write-Host "User chose to exit. Exiting..."
            exit  # Exit the script
        }
        # If No is selected, it will repeat the current step
    }
}
