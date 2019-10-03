# labreti - A networking laboratory using Virtualbox
This repository contains the scripts to generate two VirtualBox virtual machines that can be used to perform experiments in networking using a PC.

Creating the two VMs is a quite long process: with a good computer and network connection it takes one or two hours of work. The step are not many, but most of them take tens of minutes to complete.

## Forewords

The content of this repository is intended to help the expert to rapidly configure a virtual environment. It is not meant to be a step by step guide for the beginner. The whole process may depend on software updates occurred after the last time I used it, so you may expect that a limited number of fixes are needed.

## Creating the virtual infrastructure

You first need to install VirtualBox: you can [download](https://www.virtualbox.org/wiki/Downloads) it from the Oracle site. This guide referes to version 6.0.

In the network management window check that one local network is available, and that the DHCP server is enabled.

Create a virtual machines with the following features:

* 512MB of RAM
* PAE/NX enabled
* VT-x enabled
* Nested paging enabled
* 6GB virtual HD
* Two network interfaces, one configured as NAT, another as "Host only"

You can reduce the RAM and HD if needed, but not too much.

Next [download](http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-i386/current/images/netboot/mini.iso) the ISO image of Ubuntu Bionic (18.04) in the "MinimalCD" release for a 32bit (i386) machine.

### Build a vanilla VM

This step is helpful to avoid rebuilding the core VM, and helps to develop alternate VM without reinstalling each time.

Mount the "mini.iso" file previously download in the IDE controller of the VM you have just created. 

Start the VM and follow the installation wizard configuring the approriate language, keyboard etc.. During this step

* set the name of the computer as "vanilla" for compatibility with these notes
* for the name of the user enter "studente" with password "studente", for compatibility with the installation script
* do not allow automatic upgrades
* when prompted for additional software do not select anything (at most, the SSHserver, near the bottom of the list)

When the installation is finished, shut down the machine and remove the installation disk from the (virtual) IDE drive.

Now you can save your work as a OVA file: it is not strictly needed but may be useful.

In the sequel I will refer to "desktop" and "server" VMs. The former is configured with a graphical desktop interface, the other is a server with command line interface.

### Building the "destop" VM

Clone the vanilla machine and name it "desktop": a linked clone is OK, and saves a lot of time and disk space.

Run the VM and login as "studente".
Install the "git" toolset and install the lubuntu-core tasksel package (notice the ^):
```
$ sudo apt install -y git lubuntu-core^ 
$ sudo halt
```
Run again the VM, this time with a graphical interface. Login as student and open a terminal. Next clone this repository in the VM, move into the newly created directory and launch the configuration script, as follows:
```
$ git clone https://github.com/AugustoCiuffoletti/labreti
$ cd labreti
$ sudo bash build_desktop.sh
```
When asked, allow the non-superuser to capture packets with Wireshark

The desktop machine has a graphical desktop interface. There are some useful tools installed; among the others:

* Dillo, a lightweigth browser
* Geany, a lightweight IDE
* Wireshark, a packet analyzer
* packETH, a packet generator
* curl, a CLI tool for HTTP
* Python, language support for v2 (default) and v3 with environments (virtualenv)
* Flask, a WSGI web application framework for Python
* the CLI for Heroku, a cloud platform of web applications
* the Arduino IDE, useful only for demos since the use of USB ports as a serial line is impractical

### Building the "server" VM

Clone the vanilla machine as "server", next install git, clone the repo and launch the script:
$ sudo apt install git 
$ git clone https://github.com/AugustoCiuffoletti/labreti
$ cd labreti
$ sudo bash build_server.sh
```

When the script terminates you need to force a shutdown by closing the machine window because the terminal does not respond.

The "server" VM is mainly used ass a target for packets. It is equipped with a legacy LAMP server to allow HTTP traffic with minimal effort. A MySQL server is included.

### IMPORTANT

When finished, edit the /etc/hosts file on both VM so that the correct hostname is associated to 127.0.0.1. If you followed my naming, replace "vanilla" with "desktop" or "server".

