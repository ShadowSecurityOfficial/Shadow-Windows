if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
        Exit;
    }
}

$ErrorActionPreference = 'SilentlyContinue'

$MyWallpaper="%HomeDrive%\Windows\Web\Wallpaper.jpg"
$code = @' 
using System.Runtime.InteropServices; 
namespace Win32{ 
    
     public class Wallpaper{ 
        [DllImport("user32.dll", CharSet=CharSet.Auto)] 
         static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
         
         public static void SetWallpaper(string thePath){ 
            SystemParametersInfo(20,0,thePath,3); 
         }
    }
 } 
'@

add-type $code 
[Win32.Wallpaper]::SetWallpaper($MyWallpaper)

choco; New-Item -Path $Profile -Type File -Force -Value "pwsh.exe -NoExit -Command 'Set-Alias -Name Get-WMIObject -Value Get-CIMInstance'"; Copy-Item  -Path %HomeDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\FireEyeVM.Common.psm1 -Destination %HomeDrive%\ProgramData\FEVM\FireEyeVM.Common\FireEyeVM.Common.psm1 -Recurse -Force

