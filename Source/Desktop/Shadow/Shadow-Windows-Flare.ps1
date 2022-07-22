if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
        Exit;
    }
}

while (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
    echo "No internet connection found, retrying."
    Start-Sleep -Seconds 30   
}

$ErrorActionPreference = 'SilentlyContinue'

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install git -y
choco install powertoys -y
choco install groupy -y
choco install vagrant -y
choco install virtualbox -y
choco install virtualbox-guest-additions-guest.install -y
refreshenv
Invoke-WebRequest https://downloads.sourceforge.net/project/pentestbox/PentestBox-with-metasploit-2.3.exe?ts=gAAAAABi2sJ6q1WQaGLdu30kXraIm-LfVbUx4XwYMrAc9ggcZVrWvwZzuiKjoBALQMgfZ1QkHiKARd3pIn3I3DfnjBEBPZi3Kw%3D%3D&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpentestbox%2Ffiles%2FPentestBox-with-metasploit-2.3.exe%2Fdownload -o pentestbox-with-metasploit.exe
Remove-Item .\flare-vm -Recurse -Force
git clone https://github.com/mandiant/flare-vm.git .\flare-vm
git clone https://github.com/trustedsec/ptf .\ptf
Unblock-File .\flare-vm\install.ps1
Set-ExecutionPolicy Unrestricted -f
& powershell.exe -NoProfile -Command ".\flare-vm\install.ps1"
