# Create installation directory
param(
    [string]$install_path = "C:\Temp\WingetInstall"
)

# "It appear the progress bar updates after every byte, which is utter madness. — OrangeDog."
# https://stackoverflow.com/questions/28682642/powershell-why-is-using-invoke-webrequest-much-slower-than-a-browser-download
$ProgressPreference = 'SilentlyContinue'

# Checar si lo corres como admin.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Este script debe ser ejecutado como administrador."
    exit 1
}

# Se crea el directorio donde se van a descargar los paquetes.
if (!(Test-Path $install_path)) {
    New-Item -ItemType Directory -Path $install_path -Force | Out-Null
}

# Se obtienen los enlaces de descarga del ultimo release de winget.
$release = Invoke-Restmethod -Uri https://api.github.com/repos/microsoft/winget-cli/releases/latest
$bundle = $release.assets | Where-Object { $_.name -like "*.msixbundle" }
$license = $release.assets | Where-Object { $_.name -like "*.xml" }
$dependencies = $release.assets | Where-Object { $_.name -like "*dependencies.zip" }

# Se utilizan dichos enlaces para descargar los archivos correspondientes.
Invoke-WebRequest -Uri $bundle.browser_download_url -Outfile "$install_path\bundle.msixbundle"
Invoke-WebRequest -Uri $license.browser_download_url -Outfile "$install_path\license.xml"
Invoke-WebRequest -Uri $dependencies.browser_download_url -Outfile "$install_path\dependencies.zip"

# Se extraen las dependencias.
Expand-Archive -Path "$install_path\dependencies.zip" -DestinationPath "$install_path\dependencies"

# Se instalan todos los paquetes y el mismo winget. Se limpia todo.
Add-AppxPackage "$install_path\dependencies\x64\Microsoft.UI.Xaml*.appx"
Add-AppxPackage "$install_path\dependencies\x64\Microsoft.VCLibs*.appx"
Add-AppxProvisionedPackage -Online -PackagePath "$install_path\bundle.msixbundle" -LicensePath "$install_path\license.xml" -Verbose
Remove-Item -Path $install_path -Recurse -Force
