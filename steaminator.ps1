$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
exit $LASTEXITCODE
}

set-ExecutionPolicy unrestricted
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$InstallDir='C:\ProgramData\chocoportable'
$env:ChocolateyInstall="$InstallDir"

If(-Not (Test-Path -Path "$env:ProgramData\Chocolatey"))
{
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

refreshenv
  
#Installs sublime, adobe air, and google chrome
choco install sublimetext3 -y
choco install adobeair -y
choco install googlechrome -y

#Creates folder for downloads
mkdir c:\installcentral

#Downloads scratch and p5 as zip 
Invoke-WebRequest 'http://llk.github.io/scratch-msi/Scratch2_MSI_454.zip' -OutFile 'c:\installcentral\scratch2_MSI.zip'
Invoke-WebRequest 'https://github.com/processing/p5.js/releases/download/0.6.1/p5.zip' -OutFile 'c:\installcentral\p5.zip'

#Unzips p5 and scratch to install central 
Expand-Archive c:\installcentral\scratch2_MSI.zip -DestinationPath c:\installcentral
Expand-Archive c:\installcentral\p5.zip -DestinationPath "$env:Public\Desktop\p5"

#black magic to install scratch msi - will be prompts 
c:\installcentral\Scratch2_MSI.exe /s /x /b"c:\installcentral" /v"/qn"
refreshenv
Start-Process msiexec.exe -Wait -ArgumentList '/I c:\installcentral\Scratch2_MSI.msi'



