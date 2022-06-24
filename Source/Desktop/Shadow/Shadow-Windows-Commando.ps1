Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.36.1.windows.1/Git-2.36.1-64-bit.exe -o git.exe
.\git.exe /SILENT
git clone https://github.com/mandiant/commando-vm.git
cd commando-vm
Unblock-File .\install.ps1
Set-ExecutionPolicy Unrestricted -f
.\install.ps1
