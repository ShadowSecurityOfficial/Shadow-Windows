# How to use?

Boot into ISO and install, after install connect to the internet and use snappy driver installer to install drivers (if you are on a virtual machine you should install the virtual machine drivers). After this, click the script on the desktop inside the Shadow folder that you want to turn the machine into, currently you have two options:

Commando (Offensive Security) Or Flare (Cyber Forensics)

Run the powershell script you chose accordingly, reboot after it is done, and you are all set to work inside windows. (If you get any errors when running the script rerun the script. it will retry and try to automatically fix the errors, the most common issue is network problems.)

If you keep receiving errors I highly suggest you use (https://pentestbox.org/) which is automatically downloaded upon running the Shadow-Commando or Shadow-Flare script, all you need to do is run the .exe The installation for CommandoVM and FlareVM is generally regarded as unstable. If you'd like to add tools to the distribution I also automatically git clone the PTF project for you. If you are not pleased with either of this options I haved also preinstalled vagrant and virtualbox so you can quickly get a penetration testing distribution of your choice up and running fast using vagrant/virtualbox, if you are wondering virtualbox guest additions is also installed.
