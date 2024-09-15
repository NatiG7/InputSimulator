# InputSimulator.ps1

## Overview

`InputSimulator.ps1` is a PowerShell script designed to simulate keyboard inputs and mouse clicks using .NET's `System.Windows.Forms` library. This script allows you to automate interactions with user interface elements by sending keystrokes and mouse events.

## Features

- Simulate key presses.
- Simulate mouse clicks and movements.
- Prompt user with Yes/No dialogs between actions.

## Usage

1. **Run the Script:** Execute the script in PowerShell.
2. **Follow Prompts:** After simulating inputs and clicks, the script will prompt you with a Yes/No dialog.
3. **Respond to Prompts:** Choose Yes or No to continue or halt further actions.

### Example

```powershell
# Simulate key press (e.g., Enter key)
Simulate-KeyPress -Key 'Enter'

# Simulate mouse click at coordinates (X: 100, Y: 200)
Simulate-MouseClick -X 100 -Y 200

# Prompt user
Prompt-User -Message "Is the setup complete?" -YesAction { Write-Host "User selected Yes" } -NoAction { Write-Host "User selected No" }
```
