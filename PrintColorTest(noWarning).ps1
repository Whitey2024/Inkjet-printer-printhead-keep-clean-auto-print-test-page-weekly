# Creates a simple color test page (CMYK blocks) and prints it to the default printer
# Designed to keep inkjet nozzles clear

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$bitmap = New-Object System.Drawing.Bitmap 850, 1100  # Roughly letter size at 100 dpi
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([System.Drawing.Color]::White)

$font = New-Object System.Drawing.Font "Arial", 14
$brushBlack = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Black)

# Title
$graphics.DrawString("Inkjet Color Cleaning Page - $(Get-Date -Format 'yyyy-MM-dd')", $font, $brushBlack, 50, 30)

# Color blocks (Cyan, Magenta, Yellow, Black + some mixes)
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

$graphics.DrawString("Print this page weekly to help prevent clogged nozzles.", $font, $brushBlack, 50, $y + 20)

$graphics.Dispose()

# Print the image
$printDoc = New-Object System.Drawing.Printing.PrintDocument
$printDoc.DocumentName = "Inkjet Color Cleaning Page"

$printDoc.add_PrintPage({
    param($sender, $e)
    $e.Graphics.DrawImage($bitmap, 0, 0)
    $e.HasMorePages = $false
})

try {
    $printDoc.Print()
    Write-Host "Color test page sent to printer."
}
catch {
    Write-Host "Error printing: $_"
}
finally {
    $bitmap.Dispose()
    $printDoc.Dispose()
}