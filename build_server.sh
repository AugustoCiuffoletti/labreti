#!/bin/bash

# ATTENZIONE: VA ESEGUITO SULLA MACCHINA VIRTUALE

fail() { echo -e "\n===\nErrore\n===\n"; exit 1; }

# Configurazione automatica rete hostonly
cat > /etc/netplan/enp0s8.yaml <<EOF
# The hostonly network interface
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
      dhcp4: true
EOF

# sudo senza password
cat > /etc/sudoers.d/studente <<EOF
studente ALL=(ALL:ALL) NOPASSWD:ALL
EOF
sudo chmod 0440 /etc/sudoers.d/studente

# motd con indirizzo IP e MAC
cat > /etc/update-motd.d/92-vminfo <<"EOF"
#!/bin/sh
IPaddr=`ip addr show dev enp0s8 | egrep "inet\b" | tr -s " " | cut -f3 -d " "`
MACaddr=`ip link | grep -A2 enp0s8 | tail -1 | tr -s " " | cut -f 3 -d " "`
echo " * IP address: $IPaddr"
echo " * MAC address: $MACaddr"
EOF
sudo chmod a+x /etc/update-motd.d/92-vminfo

if ! apt-get -y update; then fail; fi
if ! apt-get -y upgrade; then fail; fi
if ! apt-get -y install traceroute curl wget; then fail; fi

# autologin su tty01
cat autologin@.service > /etc/systemd/system/autologin@.service
systemctl daemon-reload
systemctl disable getty@tty1
systemctl enable autologin@tty1
systemctl start autologin@tty1


