# Create installation directory
param(
    [string]$install_path = "C:\Temp\WingetInstall"
)

# Checar si lo corres como admin.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Este script debe ser ejecutado como administrador."
    exit 1
}


if (!(Test-Path $install_path)) {
    New-Item -ItemType Directory -Path $install_path -Force | Out-Null
    Write-Host "Directorio de descargas temporal creado en: $install_path" -ForegroundColor Green
}

Write-Host "Obteniendo enlaces de descarga." -ForegroundColor Green
$release = Invoke-Restmethod -Uri https://api.github.com/repos/microsoft/winget-cli/releases/latest
$bundle = $release.assets | Where-Object { $_.name -like "*.msixbundle" }
$license = $release.assets | Where-Object { $_.name -like "*.xml" }
$dependencies = $release.assets | Where-Object { $_.name -like "*dependencies.zip" }

Write-Host "Descargando paquetes." -ForegroundColor Green
Start-BitsTransfer -Source $bundle.browser_download_url -Destination "$install_path\bundle.msixbundle" -DisplayName "Descargando winget."
Start-BitsTransfer -Source $dependencies.browser_download_url -Destination "$install_path\dependencies.zip" -DisplayName "Descargando dependencias."
Start-BitsTransfer -Source $license.browser_download_url -Destination "$install_path\license.xml" -DisplayName "Descargando licencia."

Write-Host "Extrayendo dependencias." -ForegroundColor Green
Expand-Archive -Path "$install_path\dependencies.zip" -DestinationPath "$install_path\dependencies"

Write-Host "Instalando dependencias." -ForegroundColor Green
Add-AppxPackage "$install_path\dependencies\x64\Microsoft.UI.Xaml*.appx"
Add-AppxPackage "$install_path\dependencies\x64\Microsoft.VCLibs*.appx"

Write-Host "Instalando winget." -ForegroundColor Green
Add-AppxProvisionedPackage -Online -PackagePath "$install_path\bundle.msixbundle" -LicensePath "$install_path\license.xml"

if ($?) {
    Write-Host "Winget instalado con exito." -ForegroundColor Green
    Remove-Item -Path $install_path -Recurse -Force
    exit
}

Write-Error "Ocurrieron errores al instalar winget."
