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

Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.36.1.windows.1/Git-2.36.1-64-bit.exe -o git.exe
.\git.exe /SILENT
git clone https://github.com/mandiant/commando-vm.git
cd commando-vm
Unblock-File .\install.ps1
Set-ExecutionPolicy Unrestricted -f
.\install.ps1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d \Windows\Web\Wallpaper.jpg /f
Start-Sleep -s 10
rundll32.exe user32.dll, UpdatePerUserSystemParameters, 0, $false