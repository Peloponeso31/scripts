# ===== PHASE 2: HARD-DISABLE MICROSOFT HYPERVISOR/VBS =====

# 0) Feature list
$features = @(
  "Microsoft-Hyper-V-All",
  "HypervisorPlatform",
  "VirtualMachinePlatform",
  "Containers",
  "Containers-DisposableClientVM",
  "Microsoft-Windows-Subsystem-Linux"
)

# 1) Audit current states (handles each feature individually to avoid the error you saw)
"--- Feature states BEFORE ---"
$features | ForEach-Object {
  Get-WindowsOptionalFeature -Online -FeatureName $_ |
  Select-Object FeatureName, State
} | Format-Table -AutoSize

# 2) Disable all features (again, one-by-one)
$features | ForEach-Object {
  try {
    Disable-WindowsOptionalFeature -Online -FeatureName $_ -NoRestart -ErrorAction SilentlyContinue | Out-Null
  }
  catch {}
}

 

# 3) Ensure hypervisor + VBS are off for ALL boot entries (not just {current})
#    Some systems keep multiple boot loaders; set both toggles everywhere.
$ids = (bcdedit /enum) | Select-String -Pattern 'identifier\s+(\{[^\}]+\})' |
ForEach-Object { ($_ -split '\s+')[-1] } | Select-Object -Unique

foreach ($id in $ids) {
  cmd /c "bcdedit /set $id hypervisorlaunchtype off"  | Out-Null
  cmd /c "bcdedit /set $id vsmlaunchtype off"         | Out-Null  # Turn off Virtual Secure Mode at boot
}

# 4) Disable Device Guard / Credential Guard / HVCI (policy + runtime)
$regEdits = @(
  @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"; Name = "EnableVirtualizationBasedSecurity"; Type = "DWord"; Value = 0 },
  @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"; Name = "RequirePlatformSecurityFeatures"; Type = "DWord"; Value = 0 },
  @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"; Name = "HVCIMATRequired"; Type = "DWord"; Value = 0 },
  @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"; Name = "EnableVirtualizationBasedSecurity"; Type = "DWord"; Value = 0 },
  @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"; Name = "Enabled"; Type = "DWord"; Value = 0 },
  @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Name = "LsaCfgFlags"; Type = "DWord"; Value = 0 } # Credential Guard
)

foreach ($e in $regEdits) {
  if (-not (Test-Path $e.Path)) { New-Item -Path $e.Path -Force | Out-Null }
  New-ItemProperty -Path $e.Path -Name $e.Name -PropertyType $e.Type -Value $e.Value -Force | Out-Null
}

# 5) Stop & disable leftover services
$svc = @("vmms", "vmcompute", "hns")
foreach ($s in $svc) {
  if (Get-Service -Name $s -ErrorAction SilentlyContinue) {
    try { Stop-Service $s -Force -ErrorAction SilentlyContinue } catch {}
    try { Set-Service  $s -StartupType Disabled } catch {}
  }
}

 
# 6) Show final states (pre-reboot)
"`n--- Feature states AFTER (pre-reboot) ---"
$features | ForEach-Object {
  Get-WindowsOptionalFeature -Online -FeatureName $_ |
  Select-Object FeatureName, State
} | Format-Table -AutoSize
