# How to build Shadow-Windows?

1. Git clone our repository to your C:\Users\Public\Desktop directory
2. Grab latest AtlasOS (Security Updates ISO) and put in setup folder
3. Extract AtlasOS ISO to setup folder
4. Load into NTlite
5. Add extracted AtlasOS directory
6. Convert install.esd to install.wim if needed
7. Load install.wim
8. Load our XML file (if you get a error with loading the XMl file it is probably a issue with you following the steps or AtlasOS updated their ISO in that case I will update our XML File)
9. Hit apply and create ISO
10. Success (Boot into ISO and test it)

For those of you wondering why I do not have a CI/CD process for Shadow-Windows here is why:

NTlite does not allow CLI input and is a GUI only program, for this reason I cannot use NTlite in a CI/CD process
