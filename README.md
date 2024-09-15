# InputSimulator.ps1

## Overview

`InputSimulator.ps1` is a PowerShell script designed to simulate keyboard inputs and mouse clicks using .NET's `System.Windows.Forms` library. This script allows you to automate interactions with user interface elements by sending keystrokes and mouse events.

## Requirements

* PowerShell 5.0 or later.
* .NET Framework 4.5 or later.

## Features

- Simulate key presses.
- Simulate mouse clicks and movements.
- Prompt user with Yes/No dialogs between actions.

## Usage

1. **Run the Script:** Execute the script in PowerShell.
2. **Setup:** Define which actions and keypresses you need and set them up

    ```powershell
    # --- Step 1: Mouse Logic ---
        $step1Logic = {
        [InputSimulator]::SetMousePosition(1024, 256) # Moves mouse
    }

    # --- Step 2: Simulate Key Press ---
    $step2Logic = {
        [InputSimulator]::SetMousePosition(50, 50) # Moves mouse
        FlashMouseCursor # Moves cursor rapidly to visually identify
        [InputSimulator]::PressKey(0x41)  # Press the 'A' key
        [InputSimulator]::PressKey(0x32)
    }
    ```

3. **Execute:** Once you are satisfied with the logic and actions run the script.
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
