# Mouse Position Mapper

This PowerShell script allows users to capture and log mouse click positions on the screen. It opens a transparent form that registers mouse clicks and saves the positions to a log file along with a unique ID, timestamp, and attempt number.

## Features

- **Record Mouse Click Positions**: Captures the X and Y coordinates of mouse clicks.
- **Unique Identifiers**: Each click is assigned a unique ID and timestamp.
- **Tooltips for Instructions**: Displays tooltips with instructions for users.
- **Exit with ESC**: The script can be exited by pressing the ESC key.
- **Persisted Attempt Number**: The script keeps track of attempts, even across multiple runs.

## Usage

1. **Dot Source the Input Utilities and Functions**:

    ```powershell
    . .\MouseMapper.ps1
    . .\MouseMapperFunctions.ps1
    ```

2. **Display Tooltip**: The script shows a tooltip with instructions.

    ```powershell
    Show-Tooltip -message "Click anywhere on the screen to record the mouse position.`nPress ESC to exit."
    ```

3. **Capture Mouse Clicks**: The form captures mouse click positions.

    ```powershell
    $form.Add_MouseClick({
        $global:clickNumber++
        Write-MousePosition -filePath $positionsFilePath -attemptNumber $attemptNumber -clickNumber $clickNumber
        Set-Content -Path $attemptNumberFilePath -Value $attemptNumber
        Start-Sleep -Milliseconds 500
    })
    ```

4. **Exit Script**: Press ESC to exit the mapper.

    ```powershell
    $form.Add_KeyPress({
        if ($args[1].KeyChar -eq [char][System.Windows.Forms.Keys]::Escape) {
            Write-Host "Exiting Mouse Position Mapper."
            $form.Close()
        }
    })
    ```

## Code Snippets

### Function to Write Mouse Position to a File

```powershell
function Write-MousePosition {
    param (
        [string]$filePath,
        [int]$attemptNumber,
        [int]$clickNumber
    )
    $point = [MouseMapper]::GetMousePosition()
    $uniqueId = New-UniqueId
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $position = "Click number $clickNumber : $uniqueId, $timestamp, X=$($point.X), Y=$($point.Y)"
    Add-Content -Path $filePath -Value $position
    Write-Host "Position recorded: Attempt $attemptNumber, Click $clickNumber, ID $uniqueId, Date $timestamp"
}
```
