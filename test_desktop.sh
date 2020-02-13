#!/bin/bash
set -e

echo -e "\ntest ifconfig"
ifconfig --version
echo -e "\ntest traceroute"
traceroute --version
echo -e "\ntest wireshark"
wireshark --version | head -1
echo -e "\ntest packeth"
which packeth
echo -e "\ntest nc"
nc 2>&1 >/dev/null | head -1
echo -e "\ntest geany"
geany --version
echo -e "\ntest git"
git --version

