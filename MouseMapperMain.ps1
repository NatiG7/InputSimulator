# Dot source the InputUtils and Functions
. .\MouseMapper.ps1
. .\MouseMapperFunctions.ps1

# Display the tooltip with instructions
Show-Tooltip -message "Click anywhere on the screen to record the mouse position.`nPress ESC to exit."

# Initialize the form for mouse click events
$form = New-Object System.Windows.Forms.Form
$form.Text = "Mouse Position Mapper"
$form.Size = New-Object System.Drawing.Size(300,100)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true

# Handle the mouse click event
$form.Add_MouseClick({
    $attemptNumber++
    Write-MousePosition -filePath $positionsFilePath -attemptNumber $attemptNumber

    # Save the new attempt number to file
    Set-Content -Path $attemptNumberFilePath -Value $attemptNumber

    # Small delay to avoid multiple recordings with a single click
    Start-Sleep -Milliseconds 500
})

# Show the form to capture clicks
$form.ShowDialog()

# Check if ESC is pressed to exit
while ($form.Visible) {
    Start-Sleep -Milliseconds 100
    if ([System.Windows.Forms.Control]::ModifierKeys -eq [System.Windows.Forms.Keys]::Escape) {
        Write-Host "Exiting Mouse Position Mapper."
        $form.Close()
    }
}
