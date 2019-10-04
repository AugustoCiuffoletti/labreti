# labreti - A networking laboratory using VirtualBox
This repository contains the scripts to build two VirtualBox virtual machines (VMs) that can be used to perform experiments in networking using a normal PC.

The building process does not depend on the operating system of the PC of the technician (or teacher) that creates the virtual laboratory. In the same way, the virtual laboratory does not depend on the operating system of the student PC.In both cases the VirtualBox application must be installed on the PC. For the records, I have developed the scripts and these instructions using a laptop with an Ubuntu OS, and I have seen the laboratory running on Linux, Mac and Windows laptops. 

The requirements for student's PCs are the following:

* hardware virtualization is enabled (VT-x or AMD-V)
* at least 1 GB of RAM is available (in excess of that required by the OS and other applications, VirtualBox included)
* at least 15 GB of HD is free
* Internet access is not strictly required

If you want to try please carefully read the forewords.

## Forewords

Creating the two VMs is a quite long process: with a good computer and network connection it takes one or two hours of work. The steps are not many, but most of them take tens of minutes to complete.

The content of this repository is intended to help the expert to configure the virtual laboratory. It is not meant to be a step by step guide for the beginner. If in doubt whether you are prepared or not, peek into the .sh files: if your reaction is "That's it?" your probability of success is high.

**DO NOT** run the scripts on your PC. If you avoid this your chances to make any damage are limited.

The whole process may depend on software updates occurred after the last time I used it, so you may expect that a limited number of fixes are needed.

## Creating the virtual infrastructure

You first need to install VirtualBox: [download](https://www.virtualbox.org/wiki/Downloads) it from the Oracle site. This guide refers to version 6.0.

In the "Host Network Manager" window create a network for the virtual laboratory and enable the DHCP service.

Next create two virtual machines with the following features:

* 512MB of RAM
* PAE/NX enabled
* VT-x enabled
* Nested paging enabled
* 6GB virtual HD
* Two network interfaces, one configured as NAT, another as "Host only"

You can reduce the RAM and HD if needed, but not too much.

**DO NOT CLONE** the virtual machines to save time at this stage. Instead, be patient and install each of them as follows.

### Build vanilla VMs

The next step is to [download](http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-i386/current/images/netboot/mini.iso) the ISO image of Ubuntu Bionic (18.04) in the "MinimalCD" release for a 32bit (i386) CPU.

Then repeat the following steps for each of the two VMs:

* Mount the "mini.iso" file previously download in the IDE controller of the VM

* Start the VM and follow the installation wizard configuring the approriate language, keyboard etc.. During this step

    * set the name of the computer as "desktop" for one VM, as "server" for the other VM. Keep such names for compatibility with these notes
    * for the name of the user enter "studente" with password "studente", for compatibility with the installation script
    * do not allow automatic upgrades
    * when prompted for additional software do not select anything

* shut down the VM and remove the installation disk from the (virtual) IDE drive.

In the sequel I will refer to "desktop" and "server" VMs. The former is going to be configured with a graphical desktop interface, the other as a server with a command line interface.

### Building the "destop" VM

Clone the "desktop" machine as a "linked clone". This is not mandatory but gives you the possibility to recover the vanilla VM, thus saving a lot of time.

Run the cloned VM and login as "studente".
Install the "git" toolset and the lubuntu-core tasksel package (notice the ^):
```
$ sudo apt install git lubuntu-core^ 
```
Shutdown and restart the VM, that now offers a graphical interface. Login as "studente" and open a terminal. Clone this repository in the VM, move into the newly created directory and launch the `build_desktop.sh` script, as follows:
```
$ git clone https://github.com/AugustoCiuffoletti/labreti
$ cd labreti
$ sudo bash build_desktop.sh
```
When asked, allow the non-superuser to capture packets with Wireshark.

The desktop machine has a graphical desktop interface and some useful applications are available:

* Dillo, a lightweigth browser
* Geany, a lightweight IDE
* Wireshark, a packet analyzer
* packETH, a packet generator
* cURL, a CLI tool for HTTP
* Python, language support for v2 (default) and v3 with environments (virtualenv)
* Flask, a WSGI web application framework for Python
* the CLI for Heroku, a cloud platform of web applications
* the Arduino IDE, useful only for demos since the use of USB ports as a serial line is impractical

### Building the "server" VM

Clone the "server" VM and install on the clone the "git" toolset. Next clone this repo and launch the `build_server.sh` script:
```
$ sudo apt install git 
$ git clone https://github.com/AugustoCiuffoletti/labreti
$ cd labreti
$ sudo bash build_server.sh
```
When the script terminates you need to force a shutdown by closing the machine window because the terminal does not respond. The VM will be responsive after the following reboot.

The "server" VM is mainly used as a target for packets. It is also equipped with a legacy LAMP server to allow HTTP traffic. A MySQL server is included.

## Prepare the delivery

The two VMs are now ready to be delivered to the students. For this you may pack both of them into a single OVA file.

To reduce the size of such file it is preferable to use the "cleanup.sh" script, after the VM has been tested. The reduction in size is substantial, so this step is strongly recommended for both VMs. Again, be patient since HD cleanup is quite long. In the end, remove the "labreti" directory from student's home:
```
$ cd labreti
$ sudo bash cleanup.sh
$ cd ..
$ rm -rf labreti
```
and shut down the VMs.

Now select the two VMs in the VirtualBox dashboard and follow the "Export Appliance..." wizard in the "File" menu. The size of the .ova file containing the two VMs is less than 2GB.

## Using the Virtual Laboratory

Each student has the VirtualBox application installed on the PC: its installation is a straightforward task. One local network needs to be configured: the teacher should give precise instructions about this, since it is preferable that all students share 
the same IP addresses in their Virtual Laboratory.

The .ova file can be distributed either on the local network, or using a USB key. Once the file is on student's PC the two machines are extracted using the "Import virtual appliance..." wizard in the File menu.

The `cleanup.sh` script has removed the package indexes. In case you need to install other ubuntu packages on the VM you need to rebuild them with:
```
sudo apt update
```
In the "Activities" directory of this package you find a synthetic summary of many activities that can be carried out using the virtual laboratory.