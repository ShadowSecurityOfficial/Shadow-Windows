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
choco install powershell-core -y
refreshenv
Remove-Item .\commando-vm -Recurse -Force
git clone https://github.com/mandiant/commando-vm.git .\commando-vm
Unblock-File .\commando-vm\install.ps1
Set-ExecutionPolicy Unrestricted -f
& pwsh.exe -NoProfile -Command "Set-Alias -Name Get-WMIObject -Value Get-CIMInstance; .\commando-vm\install.ps1"
