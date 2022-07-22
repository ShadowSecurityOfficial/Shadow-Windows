# How to build Shadow-Windows?

First make sure you are connected to the internet.

1. Git clone our repository to your preferred directory (Script to download Git Portable included in directory)
2. Grab latest Custom Windows ISO and put in our repository directory (You can grab it using the script in Setup directory if you prefer)
3. Extract Custom Windows ISO to setup folder using Winrar or 7-zip (Script included to download the installer for these utilities in the Setup folder)
4. Download and Load into NTlite (Script to download NTlite installer included in directory)
5. Load extracted Custom Windows ISO directory
6. Convert install.esd to install.wim if needed
7. Load install.wim

8. (Put the files in the source folder to the necessary directories) make sure you have display hidden folders setting on:

```
- Source/Web >> %temp%\NLTmpMnt01\Windows\Web (Delete the existing folder first!)
- Source/Desktop/Shadow >> %temp%\NLTmpMnt01\Users\Administrator\Desktop\Shadow
- Setup/Shadow-Windows.ps1 >> %temp%\NLTmpMnt01\ProgramData\Microsoft\Windows\Start Menu\Programs\Shadow-Windows.ps1
- Setup/Shadow-Windows.ps1 >> %temp%\NLTmpMnt01\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Shadow-Windows.bat
```

9. Hit apply and create ISO (Make sure the backup log checkbox is disabled, Save the image and trim editions save mode, ESD image format compression mode, Make sure the name is Shadow-Windows.)

For those of you wondering why I do not have a CI/CD process for Shadow-Windows here is why:

NTlite/PowerISO does not allow CLI input and is a GUI only program, for this reason I cannot use NTlite/PowerISO in a CI/CD process

(After downloading any tool used in the build process I suggest you verify the checksum with OpenHashTab to make sure the file is not corrupted or tampered.)
