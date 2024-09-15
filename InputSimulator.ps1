# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Function to check if a type already exists and prompt the user to restart
function Remove-Type {
    param (
        [string]$typeName
    )

    $appDomain = [AppDomain]::CurrentDomain
    $assemblies = $appDomain.GetAssemblies()
    $typeFound = $false

    foreach ($assembly in $assemblies) {
        try {
            $types = $assembly.GetTypes()
            foreach ($type in $types) {
                if ($type.Name -eq $typeName) {
                    Write-Host "Type '$typeName' exists in assembly: $($assembly.FullName)"
                    $typeFound = $true
                    break
                }
            }
        } catch {
            Write-Host "Error while checking assembly: $_"
        }
    }

    if ($typeFound) {
        Write-Host "`nA conflicting type '$typeName' has been found in the current PowerShell session."
        Write-Host "Please restart PowerShell to clear the loaded types before rerunning this script."
        Write-Host "You can restart PowerShell manually or use 'Stop-Process -Id $PID -Force' to force a reset."
        exit  # Prevent further execution
    } else {
        Write-Host "Type '$typeName' not found."
    }
}

# Define the InputSimulator class
function Add-InputSimulator {
    Write-Host "Creating new Type InputSimulator"
    Add-Type @"
using System;
using System.Runtime.InteropServices;

public class InputSimulator
{
    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);
    
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);
    
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int X, int Y);
    
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    public struct POINT
    {
        public int X;
        public int Y;
    }

    public struct MousePosition
    {
        public int X;
        public int Y;
    }

    // Set the mouse position
    public static void SetMousePosition(int x, int y)
    {
        SetCursorPos(x, y);
    }

    // Get the current mouse position
    public static MousePosition GetMousePosition()
    {
        POINT point;
        GetCursorPos(out point);
        MousePosition position;
        position.X = point.X;
        position.Y = point.Y;
        return position;
    }

    public static void ClickMouse()
    {
        mouse_event(0x0002, 0, 0, 0, 0); // Mouse button down
        mouse_event(0x0004, 0, 0, 0, 0); // Mouse button up
    }

    public static void PressKey(byte key)
    {
        keybd_event(key, 0, 0, 0); // Key down
        keybd_event(key, 0, 0x0002, 0); // Key up
    }
}
"@
    Write-Host "Type 'InputSimulator' created."
}

# Remove the existing InputSimulator type if it exists
Remove-Type -typeName "InputSimulator"

# Add the InputSimulator class
Add-InputSimulator
