# How to build Shadow-Windows?

1. Git clone our direcctory in C:\ Drive
2. Grab latest AtlasOS (Security Updates ISO) and put in setup folder
3. Extract AtlasOS ISO to setup folder
4. Load into NTlite
5. Convert install.esd to install.wim if needed
6. Load install.wim
7. Download and extract the necessary tools to the Setup directory. (Git Portable)
8. Load our XML file
9. Hit apply and create ISO
10. Success (Boot into ISO and test it)

For those of you wondering why I do not have a CI/CD process for Shadow-Windows here is why:

NTlite does not allow CLI input and is a GUI only program, for this reason I cannot use NTlite in a CI/CD process
