## 💻 PowerShell Scripts Usage Guide

These scripts are designed to be executed in an **elevated command prompt (Run as Administrator)**.

### ⚡ Quick Execution (No Download or `$Set-ExecutionPolicy` Needed)

To run the scripts directly, use the `irm | iex` format (Invoke-RestMethod | Invoke-Expression), as shown in each section below.

> **Note:** Some script outputs are in Spanish, as it is my native language. This output should generally be irrelevant for automated actions.

-----

## 🛠️ Available Scripts

### 1\. Winget Installation Script

Script to install **Winget** on x64 systems (including LTSC), along with its necessary dependencies.

```powershell
irm https://raw.githubusercontent.com/Peloponeso31/scripts/refs/heads/main/winget.ps1 | iex
```

### 2\. CPL0 Optimization for VMWare Workstation Pro

#### A. Disable Hyper-V and WSL (Custom Tool)

This script completely removes components related to **Hyper-V** and **WSL**, which can restore the **CPL0** execution mode in VMWare.

This is not mine, honest to god I don't remember where I got this.

> **⚠️ Warning:** **Use with caution**, as it impacts native Windows virtualization features.

```powershell
irm https://raw.githubusercontent.com/Peloponeso31/scripts/refs/heads/main/hyperv-remover.ps1 | iex
```

#### B. Disable Device Guard and Credential Guard (Microsoft Tool)

**Device Guard** and **Credential Guard** are known features for impeding the execution of virtual machines in **CPL0** mode, often defaulting to the slower ULM monitor mode.

This official Microsoft script (`dg-readiness-tool.ps1`) can be used to disable them.

**Since this tool requires arguments, it is better to download it and execute it locally:**

1.  Ensure you have the **appropriate execution policy** set (e.g., `Set-ExecutionPolicy Unrestricted` temporarily if needed).
2.  Run the script with the disable argument:

<!-- end list -->

```powershell
.\dg-readiness-tool.ps1 -Disable
```
