# Uses of these scripts
To use these scripts without downloading them nor fiddling with `Set-ExecutionPolicy`, use `irm | iex` commands such as the following:

Some script outputs are in spanish because it is my natural language, should be mostly irrelevant because these are automated actions.

These script should be executed in an elevated prompt.

## Winget installation script
Script to install winget to x64 systems (including LTSC) with their dependencies.
```powershell
irm https://raw.githubusercontent.com/Peloponeso31/scripts/refs/heads/main/winget.ps1 | iex
```

## Scripts to ensure CPL0 on VMWare Workstation Pro
This script removes anything to do with Hyper-V and WSL, use with caution.
```powershell
irm https://raw.githubusercontent.com/Peloponeso31/scripts/refs/heads/main/hyperv-remover.ps1 | iex
```

This is an official Microsft script to fiddle with Device Guard and Credential Guard. Its description reads: "Tool to check if your device is capable to run Device Guard and Credential Guard.".

It can be used to remove them, because these features are known for impeding the execution of CPL0 virtual machines, defaulting to the slower ULM monitor mode.

Because this script takes arguments, it is better to download it, ensure `Set-ExecutionPolicy Unrestricted` and then:

```
.\dg-readiness-tool.ps1 -Disable
```