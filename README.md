# Input Simulator

## Overview

`InputSimulator.ps1` is a PowerShell script designed to simulate keyboard inputs and mouse clicks using .NET's `System.Windows.Forms` library.\
This script allows you to automate interactions with user interface elements by sending keystrokes and mouse events.

## Requirements

* PowerShell 5.0 or later.
* .NET Framework 4.5 or later.

## Features

- Simulate key presses,mouse clicks and movements.
- Prompt user with Yes/No dialogs between actions.
- Contains utility methods for working with the script.
- Added a mouse mapping utility to be used with the simulator

## Methods

Available Methods :\
[For MouseMapper please refer to MouseMapper README.md]
```
[InputSimulator]::SetMousePosition(int x, int y) - moves mouse to x,y
[InputSimulator]::GetMousePosition() - returns current x,y
[InputSimulator]::ClickMouse() - simulate a click
[InputSimulator]::PressKey(byte key) - e.g 0x41 = 'A'
```

## Usage

1. **Run the Script:** Execute the script in PowerShell.
   * Note  : you can either run {script}Main.ps1 to load the methods and functions
   * or load running one by one
3. **Setup:** Define which actions and keypresses you need and set them up, e.g :

    ```powershell
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
    ```

4. **Execute:** Once you are satisfied with the logic and actions run the script.
It will prompt a yes/no dialog between every stepLogic in *...Main.ps1

### Example

```powershell
# Simulate key press (e.g., Enter key)
Simulate-KeyPress -Key 'Enter'

# Simulate mouse click at coordinates (X: 100, Y: 200)
Simulate-MouseClick -X 100 -Y 200

# Prompt user
Prompt-User -Message "Is the setup complete?" -YesAction { Write-Host "User selected Yes" } -NoAction { Write-Host "User selected No" }
```
