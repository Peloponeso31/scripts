# Array of Winget IDs for programs to install
$programs = @(
    "Spotify.Spotify",
    "Docker.DockerDesktop"
)

# Loop through each program and install it using winget
foreach ($program in $programs) {
    Write-Host "Installing $program..." -ForegroundColor Cyan
    winget install --id $program --silent --accept-package-agreements --accept-source-agreements

    if ($LASTEXITCODE -eq 0) {
        Write-Host "$program installed successfully." -ForegroundColor Green
    } else {
        Write-Host "Failed to install $program. Exit code: $LASTEXITCODE" -ForegroundColor Red
    }

    Write-Host "--------------------------------------------"
}
