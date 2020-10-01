#!/bin/bash

echo "entering setup script"

# get updates and install all necessary dependancies
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt update
apt install -y ansible gnupg python3
# needed for parsing memory dumps
pip install pyasn1

useradd -m -s /bin/bash ansible
usermod -aG sudo ansible
echo -e "ansible\nansible" | passwd ansible

echo "exiting setup script"
