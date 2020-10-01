#!/bin/bash
echo "starting cleanup script"


# move the provisioning plays, certs, and configs and change the permisions
mv /home/vagrant/plays /plays
chown -R ansible:ansible /plays
chmod 744 -R /plays

# set up the hosts file and interface
cat /home/vagrant/hosts > /etc/hosts
cat /home/vagrant/eth0 > /etc/network/interfaces.d/eth0

# move the ansible ssh keys and set permissions
mkdir -p /home/ansible/.ssh
mv /home/vagrant/ansible/* /home/ansible/.ssh/
chown -R ansible:ansible /home/ansible/.ssh/*
chmod 700 /home/ansible/.ssh/*


sed -i -e 's/iface eth0*//' -e 's/address *//' -e 's/netmask *//' -e 's/gateway *//' -e 's/dns-nameserv*//' /etc/network/interfaces
# cat /home/vagrant/eth0 > /etc/network/interfaces.d/eth0
chown -R ansible:ansible /home/ansible


# move the initial ssh config files to the right spot
cp /plays/hardenedconfig/* /etc/ssh/
chown -R root:root /etc/ssh
rm -rf /etc/ssh/ssh_host_e*
chmod 644 /etc/ssh/*
chmod 600 /etc/ssh/ssh_host_rsa_key
systemctl restart sshd

# need to make certain directories 700 (/plays)

shutdown +1 -r
echo "finishing cleanup, do not forget to change the interface" 
echo "change the root password and ansible user, delete vagrant user"
exit
