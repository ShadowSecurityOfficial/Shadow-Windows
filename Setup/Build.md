# How to build Shadow-Windows?

1. Git clone our repository to your preferred directory
2. Grab latest AtlasOS (Security Updates ISO) and put in our repository directory (You can grab it using the script in Setup directory if you prefer)
3. Extract AtlasOS ISO to setup folder using Winrar or 7-zip (Script included to download the installer for these utilities in the Setup folder)
4. Download and Load into NTlite (Script to download NTlite installer included in directory)
5. Add extracted AtlasOS directory
6. Convert install.esd to install.wim if needed
7. Load install.wim
8. Load our XML file (if you get a error with loading the XMl file it is probably a issue with you following the steps or AtlasOS updated their ISO in that case I will update our XML File) (XML file is located in Setup directory)

9. (Put the files in the source folder to the necessary directories:

```
- Source/Web >> %temp%\NLTmpMount01\Windows\Web (Delete the existing folder first!)
- Source/Desktop/Shadow >> %temp%\NLTmpMount01\Users\Default\Desktop\Shadow
```

11. Hit apply and create ISO
12. Success (Boot into ISO and test it)

For those of you wondering why I do not have a CI/CD process for Shadow-Windows here is why:

NTlite does not allow CLI input and is a GUI only program, for this reason I cannot use NTlite in a CI/CD process
