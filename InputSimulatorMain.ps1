# Dot source the InputSimulator type and functions
. .\InputSimulator.ps1
. .\InputSimulatorFunctions.ps1
### Available Methods :
# [InputSimulator]::SetMousePosition(int x, int y) - moves mouse to x,y
# [InputSimulator]::GetMousePosition() - returns current x,y
# [InputSimulator]::ClickMouse() - simulate a click
# [InputSimulator]::PressKey(byte key) - e.g 0x41 = 'A'
###

# --- Step 1: Initial setup of product ---
$step1Logic = {
    [InputSimulator]::SetMousePosition(512, 256) # Moves mouse to a selected location
    FlashMouseCursor # Debug line to highlight mouse pos after moving
    [InputSimulator]::ClickMouse() # Click at Position
    [InputSimulator]::PressKey(0x36) # Press a key ( '6' for 0x36 )

    $myPromptToUser = $null
    while ($myPromptToUser -ne [System.Windows.Forms.DialogResult]::Yes) {
        # Logic will continue to next step if user.choice is "Yes"
        $myPromptToUser = Show-YesNoDialog "{Prompt Here}"
        if ($myPromptToUser -eq [System.Windows.Forms.DialogResult]::Yes) {
            [InputSimulator]::SetMousePosition(256, 512) # Move mouse somewhere else
            FlashMouseCursor # Debug line to highlight mouse pos after moving
            [InputSimulator]::ClickMouse() # Click at new position
            $step2Logic # Move to step 2
        }
        elseif ($myPromptToUser -eq [System.Windows.Forms.DialogResult]::Cancel) {
            [System.Windows.Forms.MessageBox]::Show("User chose to exit. Exiting...")
            exit  # Exit the script
        } # Selecting No will repeat the step.
        Write-Host "This code ran after If {debug line}"
        [InputSimulator]::SetMousePosition(300, 300)
        FlashMouseCursor
    }
}

# --- Step 2: Simulate Key Press ---
$step2Logic = {
    Start-Sleep -Seconds 5 # 5s delay
    [InputSimulator]::SetMousePosition(50, 50)
    FlashMouseCursor
    [InputSimulator]::PressKey(0x41)  # Press the 'A' key
}

# --- Step 3: Print String to Console (simulating typing) ---
$step3Logic = {
    [InputSimulator]::SetMousePosition(500, 500)
    FlashMouseCursor
    [string]$textContentStep3 = "This is step 3"
    #TypeString $textContentStep3  # Simulate typing the string
    Write-Host $textContentStep3  # Print the string to the console
    [InputSimulator]::PressKey(0x41)  # Press the 'A' key
    [InputSimulator]::PressKey(0x32)
}

# --- Placeholder for Step 4 and beyond ---
$step4Logic = {
    [InputSimulator]::SetMousePosition(350, 350)
    FlashMouseCursor
    Write-Host "Placeholder for Step 4 logic"
}

# Execute steps one by one with confirmation
ExecuteStep -stepLogic $step1Logic -description "Move mouse and click" -stepNumber 1
ExecuteStep -stepLogic $step2Logic -description "Simulate pressing 'A' key" -stepNumber 2
ExecuteStep -stepLogic $step3Logic -description "Print string to console" -stepNumber 3
ExecuteStep -stepLogic $step4Logic -description "Placeholder for future logic" -stepNumber 4

# Display the current date and time
$date = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
Write-Host "Current Date and Time: $date"
