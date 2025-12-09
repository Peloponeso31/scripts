# Array of Winget IDs for programs to install
$programs = @(
	"9MSMLRH6LZF3", # Notepad
	"9MZ95KL8MR0L", # Snipping tool
	"9P8LTPGCBZXD", # Wintoys
	"9WZDNCRFJBH4", # Microsoft photos
	
	"BlenderFoundation.Blender",
	"Brave.Brave",
	"CharlesMilette.TranslucentTB",
	"Discord.Discord",
	"Git.Git",
	#"HandBrake.HandBrake",
	"Httpie.Httpie",
	"Jetbrains.toolbox",
	"KDE.KDEConnect",
	"KDE.Krita",
	"M2team.nanazip",
	#"Microsoft.DirectX",
	"Microsoft.DotNet.Runtime.9",
	"Microsoft.VisualStudioCode",
	"Microsoft.WindowsTerminal",
	"Microsoft.powershell",
	"Mojang.MinecraftLauncher",
	"MoritzBunkus.MKVToolNix",
	"Neovim.Neovim",
	"OBSProject.OBSStudio",
	"REALiX.HWiNFO",
	#"Rem0o.FanControl",
	"SamHocevar.Wincompose",
	"Starship.Starship",
	"Transmission.Transmission",
	#"Valve.steam",
	"Videolan.vlc",
	"Zen-Team.Zen-Browser"
	#"GOG.Galaxy",
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
