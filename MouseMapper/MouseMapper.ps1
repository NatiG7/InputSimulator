# Load Windows Forms assembly for capturing key presses and tooltips
Add-Type -AssemblyName System.Windows.Forms

function Remove-Type {
    # Check if type exists, attempt to remove or prompt to restart.
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

# Define a .NET class for mouse position utilities
try {
    Remove-Type -typeName "MouseMapper"
    Add-Type @"
using System;
using System.Runtime.InteropServices;

public class MouseMapper
{
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT
    {
        public int X;
        public int Y;
    }

    public static POINT GetMousePosition()
    {
        POINT point;
        GetCursorPos(out point);
        return point;
    }
}
"@
    Write-Host "Added MouseMapper Successfully"
}
catch {
    Write-Host "Error while adding Type: $_"
}
