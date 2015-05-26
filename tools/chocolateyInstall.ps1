#requires -version 4.0
#requires –runasadministrator

Set-Variable SCRIPT_PATH -option Constant -value $(Split-Path $MyInvocation.MyCommand.Path)
Set-Variable SSL_CERTIFICATE -option Constant -value (Join-Path $SCRIPT_PATH '..\certificate\GeoTrust_Global_CA.pem' | Resolve-Path)

certutil -addstore Root $SSL_CERTIFICATE
cinst puppet  --force --yes
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

puppet module install puppetlabs-powershell
puppet module install opentable-windowsfeature
puppet module install opentable-iis
puppet module install chocolatey-chocolatey
#puppet module install puppetlabs-reboot

puppet apply -e  "windowsfeature {'Web-WebServer':  installmanagementtools => true}" 
puppet apply -e  "windowsfeature {'NET-Framework-Core':}"
puppet apply -e  "windowsfeature {'Web-Asp-Net45':}"
puppet apply -e  "windowsfeature {'Desktop-Experience':}"

POWERCFG.EXE /S SCHEME_MIN  # Set power performance to high

#cinst silverlight -y
puppet apply -e "package { 'silverlight': ensure => installed, provider => 'chocolatey',}"

#	Microsoft Visual C++ Redistributables (2005, 2008, 2010, 2012)
if (!isAppInstalled -DisplayName "Microsoft Visual C++ 2005*"){ 
    puppet apply -e "package { 'vcredist2005': ensure => installed, provider => 'chocolatey',}"
}
if (!isAppInstalled -DisplayName "Microsoft Visual C++ 2008*"){ 
    puppet apply -e "package { 'vcredist2008': ensure => installed, provider => 'chocolatey',}"
}
if (!isAppInstalled -DisplayName "Microsoft Visual C++ 2010*"){ 
    puppet apply -e "package { 'vcredist2010': ensure => installed, provider => 'chocolatey',}"
if (!isAppInstalled -DisplayName "Microsoft Visual C++ 2012*"){ 
    puppet apply -e "package { 'vcredist2012': ensure => installed, provider => 'chocolatey',}"
}

#cinst powershell4 -pre -y #	Windows Management Framework 4.0
puppet apply -e "package { 'powershell4': ensure => installed, provider => 'chocolatey',}"

# DirectX 9.0.0.0
puppet apply -e "package { 'directx': ensure => installed, provider => 'chocolatey',}"

$scriptPath = $(Split-Path $MyInvocation.MyCommand.Path)
$CheckServerPrerequisites = Join-Path $scriptPath '.\CheckServerPrerequisites.ps1' | Resolve-Path
puppet apply -e  "exec { 'Check-Server-Prerequisites': command => '$CheckServerPrerequisites',  provider => powershell,}" 

#Restart-Computer


Function isAppInstalled {
    param(
     $DisplayName
    )
    try{
    return (((get-itemproperty hklm:\software\wow6432node\microsoft\windows\currentversion\uninstall\*).DisplayName -like "$DisplayName") -or
            ((get-itemproperty hklm:\software\microsoft\windows\currentversion\uninstall\*).DisplayName -like "$DisplayName"));
    }catch{}
}


Function getDotNetIntalls {
    return Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
    Get-ItemProperty -name Version -EA 0 |
    Where { $_.PSChildName -match '^(?!S)\p{L}'} |
    Select PSChildName, Version
}