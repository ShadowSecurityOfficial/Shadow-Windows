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

Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.36.1.windows.1/PortableGit-2.36.1-64-bit.7z.exe -o git.exe
Invoke-WebRequest https://www.rarlab.com/rar/winrar-x64-611.exe -o winrar.exe
Invoke-WebRequest https://www.7-zip.org/a/7z2200-x64.exe -o 7zip.exe
Invoke-WebRequest https://server2.epubg691.workers.dev/0:/WIN10.MacOS.Big.Sur.Edition.1909.x64.[The.World.Of.PC].rar -o windows_iso_password:_WPC_BigSur.rar
Invoke-WebRequest https://downloads.ntlite.com/files/NTLite_setup_x64.exe -o ntlite.exe
Invoke-WebRequest https://github.com/namazso/OpenHashTab/releases/download/v3.0.2/OpenHashTab_setup.exe -o openhashtab.exe
