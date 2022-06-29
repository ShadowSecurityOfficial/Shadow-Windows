# How to build Shadow-Windows?

First make sure you are connected to the internet.

1. Git clone our repository to your preferred directory (Script to download Git Portable included in directory)
2. Grab latest AtlasOS (1803 ISO or 20H2 Faceit ISO) and put in our repository directory (You can grab it using the script in Setup directory if you prefer)
3. Extract AtlasOS ISO to setup folder using Winrar or 7-zip (Script included to download the installer for these utilities in the Setup folder)
4. Download and Load into NTlite (Script to download NTlite installer included in directory)
5. Add extracted AtlasOS directory
6. Convert install.esd to install.wim if needed
7. Load install.wim

8. (Put the files in the source folder to the necessary directories) make sure you have display hidden folders setting on:

```
- Source/Web >> %temp%\NLTmpMnt01\Windows\Web (Delete the existing folder first!)
- Source/Desktop/Shadow >> %temp%\NLTmpMnt01\Users\Default\Desktop\Shadow
- Setup/FireEyeVM.Common.psm1 >> %temp%\NLTmpMnt01\ProgramData\Microsoft\Windows\Start Menu\Programs\FireEyeVM.Common.psm1
- Setup/Shadow-Windows.ps1 >> %temp%\NLTmpMnt01\ProgramData\Microsoft\Windows\Start Menu\Programs\Shadow-Windows.ps1
- Setup/Shadow-Windows.ps1 >> %temp%\NLTmpMnt01\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Shadow-Windows.bat

Next: inside %temp%\NLTmpMnt01\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Atlas.bat, make sure to find the success step and press enter to get text under the success step and put: PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%HomeDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Shadow-Windows.ps1'" on the first line of the success step, then save the file.
```

9. Hit apply and create ISO (Make sure the backup log checkbox is disabled, Save the image and trim editions save mode, ESD image format compression mode.)

For those of you wondering why I do not have a CI/CD process for Shadow-Windows here is why:

NTlite does not allow CLI input and is a GUI only program, for this reason I cannot use NTlite in a CI/CD process

(After downloading any tool used in the build process I suggest you verify the checksum with OpenHashTab to make sure the file is not corrupted or tampered.)
