# Called at any time something fails
Function Failed([string] $errmsg, [string] $ScriptName)
{
   Write-Warning $errmsg 
   $host.SetShouldExit(-1)  
}

# Get the current script name
$sScriptName = Split-Path $MyInvocation.MyCommand.Path -Leaf
$sScriptName = $sScriptName.Substring(0,$sScriptName.LastIndexOf('.'))

# Check for Microsoft .NET Framework
$installed = Get-WindowsFeature -Name Net-Framework-Core | Where Installed
if ($installed -eq $null)
{
    $errmsg = "Microsoft .NET Framework 3.5 not found. Please install this feature before continuing"
    Failed "$errmsg" "$sScriptName"  
}
else
{
    Write-Host -ForegroundColor Green "Microsoft .NET Framework 3.5 found"  
}


# Check for Microsoft Silverlight 
if (Test-Path -Path 'C:\Program Files (x86)\Microsoft Silverlight\5.1.30514.0\Silverlight.Configuration.exe')
{
    Write-Host -ForegroundColor Green "Microsoft Silverlight found"  
}
else
{
    $errmsg = "Microsoft Silverlight not found. Please install this feature before continuing"
    Failed "$errmsg" "$sScriptName" 
}

# Check Desktop Experience feature
$installed = Get-WindowsFeature -Name Desktop-Experience | Where Installed
if ($installed -eq $null)
{
    $errmsg = "Microsoft Desktop-Experience feature not found. Please install this feature before continuing"
    Failed "$errmsg" "$sScriptName"   
}
else
{
    Write-Host -ForegroundColor Green "Microsoft Desktop-Experience feature found"   
}

# Check Server-Media-Foundation feature
$installed = Get-WindowsFeature -Name Server-Media-Foundation | Where Installed
if ($installed -eq $null)
{
    $errmsg = "Microsoft Server-Media-Foundation feature not found. Please install this feature before continuing"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Microsoft Server-Media-Foundation feature found"    
}

Write-Host -ForegroundColor Magenta "Turning off all User Account Control (UAC) settings"
if (Test-Path -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System)
{
    Write-Host -ForegroundColor Green "Found registry key, no need to create"
}
else
{
    Write-Host -ForegroundColor Magenta "Registry key not found, creating"
    New-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Force
}

New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0 -Type DWord -Force
if ((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin).ConsentPromptBehaviorAdmin -ne 0)
{
    $errmsg = "Could not set registry HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin to value 0"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 

New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorUser -Value 0 -Type DWord -Force
if ((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorUser).ConsentPromptBehaviorUser -ne 0)
{
    $errmsg = "Could not set registry HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin to value 0"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 

New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value 0 -Type DWord -Force
if ((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA).EnableLUA -ne 0)
{
    $errmsg = "Could not set registry HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA to value 0"
    Failed "$errmsg" "$sScriptName"   
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 

New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name PromptOnSecureDesktop -Value 0 -Type DWord -Force
if ((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name PromptOnSecureDesktop).PromptOnSecureDesktop -ne 0)
{
    $errmsg = "Could not set registry HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\PromptOnSecureDesktop to value 0"
    Failed "$errmsg" "$sScriptName"  
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 

# Enable all icons in system tray
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -Value 0 -Type DWord -Force
if ((Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray).EnableAutoTray -ne 0)
{
    $errmsg = "Could not set registry HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\EnableAutoTray to value 0"
    Failed "$errmsg" "$sScriptName"   
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 

# Do not hide file extensions
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0 -Type DWord -Force
if ((Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt).HideFileExt -ne 0)
{
    $errmsg = "Could not set registry HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideFileExt to value 0"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 

# Show hidden files
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value 1 -Type DWord -Force
if ((Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden).Hidden -ne 1)
{
    $errmsg = "Could not set registry HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Hidden to value 1"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 

# Turn off automatic updates
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name AUOptions -Value 1 -Type DWord -Force
if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name AUOptions).AUOptions -ne 1)
{
    $errmsg = "Could not set registry HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\AUOptions to value 1"
    Failed "$errmsg" "$sScriptName"
}
else
{
    Write-Host -ForegroundColor Green "Success"
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name IncludeRecommendedUpdates -Value 0 -Type DWord -Force
if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name IncludeRecommendedUpdates).IncludeRecommendedUpdates -ne 0)
{
    $errmsg = "Could not set registry HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\IncludeRecommendedUpdates to value 0"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 

# Enable remote desktop 
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fSingleSessionPerUser -Value 1 -Type DWord -Force
if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fSingleSessionPerUser).fSingleSessionPerUser -ne 1)
{
    $errmsg = "Could not set registry HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\fSingleSessionPerUser to value 1"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Success"
}
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0 -Type DWord -Force
if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections).fDenyTSConnections -ne 0)
{
    $errmsg = "Could not set registry HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\fDenyTSConnections to value 0"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Success"
}


Write-Host -ForegroundColor Magenta "Turning all firewall profiles off"
Set-NetFirewallProfile Domain,Public,Private -Enabled False

Get-Volume
$cd = Get-WmiObject -Class Win32_CDROMDrive
[string]$Letter = $cd.Drive
$volume = Get-WmiObject -Class Win32_Volume -Filter "DriveLetter='$Letter'"

if ($null -ne $volume)
{
    Write-Host -ForegroundColor Magenta "Setting CD-ROM drive letter from" $cd.Drive[0] "to G"
    $volume.DriveLetter = "G:"
    $volume.Put()
}
else
{
    Write-Host -ForegroundColor Red "No CD-ROM drive found"
}


Write-Host -ForegroundColor Magenta "Setting power profile to high performance " -NoNewline
Try 
{
    $HighPerf = Powercfg -l | %{if($_.contains("High performance")) {$_.split()[3]}}
    $CurrPlan = $(Powercfg -getactivescheme).split()[3]
    if ($CurrPlan -ne $HighPerf) {Powercfg -setactive SCHEME_MIN}
    Write-Host -ForegroundColor Green "Success"
}
Catch
{
    $errmsg = "Could not set power profile to high performance"
    Failed "$errmsg" "$sScriptName"   
}


Write-Host -ForegroundColor Magenta "Dissabling IE Enhanced Security " -NoNewline
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}' -Name "IsInstalled" -Value -0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}' -Name "IsInstalled" -Value -0
Stop-Process -Name Explorer
Write-Host -ForegroundColor Green "Success"

Write-Host -ForegroundColor Magenta "Disabling Server Manager at logon"
if (Test-Path -Path HKCU:\Software\Microsoft\ServerManager)
{
    Write-Host -ForegroundColor Green "Found registry key, no need to create"
}
else
{
    Write-Host -ForegroundColor Magenta "Registry key not found, creating"
    New-Item -Path HKCU:\Software\Microsoft\ServerManager -Force
}

New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -Value 1 -Type DWord -Force
if ((Get-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon).DoNotOpenServerManagerAtLogon -ne 1)
{
    $errmsg = "Could not set registry HKCU:\Software\Microsoft\ServerManager\DoNotOpenServerManagerAtLogon to value 1"
    Failed "$errmsg" "$sScriptName"    
}
else
{
    Write-Host -ForegroundColor Green "Success"
} 