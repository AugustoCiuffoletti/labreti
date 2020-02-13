#!/bin/bash
set -e

fail() {
	echo "##### test fallito"
	exit 1
}

echo -e "\ntest ifconfig"
ifconfig --version || fail
echo -e "\ntest traceroute"
traceroute --version || fail
echo -e "\ntest wireshark"
wireshark --version | head -1  || fail
echo -e "\ntest packeth"
which packeth || fail
echo -e "\ntest nc"
nc -h 2>&1 >/dev/null | head -1  || fail
echo -e "\ntest python"
python --version || fail
pip --version || fail
echo -e "\ntest librerie python"
pip list --format=columns | grep psutil || fail
pip list --format=columns | grep virtualenv || fail
pip list --format=columns | grep Flask || fail
echo -e "\ntest geany"
geany --version || fail
echo -e "\ntest git"
git --version || fail
echo -e "\ntest host"
which host || fail
echo -e "\ntest wget"
wget -h | head -1  || fail
echo -e "\ntest openssl"
openssl version || fail
echo -e "\ntest curl"
curl --version | head -1 || fail
echo -e "\ntest heroku CLI"
heroku --version || fail
