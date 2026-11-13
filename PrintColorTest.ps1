# Inkjet color cleaning page with 5-minute advance reminder

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.NotifyIcon  # for tray balloon (optional)

# ========== 5-MINUTE REMINDER ==========
$reminderTitle = "Inkjet Printer Reminder"
$reminderMessage = "Please turn on your inkjet printer now.`n`nThe color cleaning test page will print in 5 minutes."

# Show a clear popup that stays on top
[System.Windows.Forms.MessageBox]::Show(
    $reminderMessage,
    $reminderTitle,
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
) | Out-Null

# Wait 5 minutes (300 seconds)
Start-Sleep -Seconds 300

# ========== CREATE & PRINT COLOR TEST PAGE ==========
$bitmap = New-Object System.Drawing.Bitmap 850, 1100
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([System.Drawing.Color]::White)

$font = New-Object System.Drawing.Font "Arial", 14
$brushBlack = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Black)

$graphics.DrawString("Inkjet Color Cleaning Page - $(Get-Date -Format 'yyyy-MM-dd HH:mm')", $font, $brushBlack, 50, 30)

$colors = @(
    [System.Drawing.Color]::FromArgb(0, 255, 255),   # Cyan
    [System.Drawing.Color]::FromArgb(255, 0, 255),   # Magenta
    [System.Drawing.Color]::FromArgb(255, 255, 0),   # Yellow
    [System.Drawing.Color]::Black,                   # Black
    [System.Drawing.Color]::FromArgb(0, 0, 255),     # Blue
    [System.Drawing.Color]::FromArgb(0, 255, 0),     # Green
    [System.Drawing.Color]::FromArgb(255, 0, 0),     # Red
    [System.Drawing.Color]::FromArgb(128, 0, 128)    # Purple
)

$y = 80
$blockHeight = 90
$blockWidth = 700

foreach ($color in $colors) {
    $brush = New-Object System.Drawing.SolidBrush $color
    $graphics.FillRectangle($brush, 50, $y, $blockWidth, $blockHeight)
    $brush.Dispose()
    $y += $blockHeight + 15
}

$graphics.DrawString("Weekly nozzle cleaning page - keep your inkjet healthy.", $font, $brushBlack, 50, $y + 20)
$graphics.Dispose()

$printDoc = New-Object System.Drawing.Printing.PrintDocument
$printDoc.DocumentName = "Inkjet Color Cleaning Page"

$printDoc.add_PrintPage({
    param($sender, $e)
    $e.Graphics.DrawImage($bitmap, 0, 0)
    $e.HasMorePages = $false
})

try {
    $printDoc.Print()
}
catch {
    [System.Windows.Forms.MessageBox]::Show(
        "Failed to print the color test page.`n`nError: $_",
        "Print Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}
finally {
    $bitmap.Dispose()
    $printDoc.Dispose()
}