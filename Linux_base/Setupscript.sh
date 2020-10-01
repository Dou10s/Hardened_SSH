#!/bin/bash



# the below is to provision users with their keys on BASE boxes only
for name in larry curly moe
do
    useradd -m $name -s /bin/bash
    echo -e "test\ntest" | passwd $name
    # setting local ssh certs, this is for the BASE boxes so users can SSH out
    mv /home/vagrant/certs/$name /home/$name/.ssh

    # the line below should be enabled for SERVERS so the users above can SSH in
    # cat /home/$name/.ssh/id_rsa.pub >> /home/$name/.ssh/authorized_keys
    chown -R $name:$name /home/$name/
    chmod 700 -R /home/$name/.ssh/
done
# remove all other keys and configurations from ssh, reload base versions
rm -rf /etc/ssh/ssh*
mv /home/vagrant/baseconfig/* /etc/ssh/
chown -R root:root /etc/ssh/*
chmod 644 -R /etc/ssh/*
chmod 600 /etc/ssh/ssh_host_rsa_key

# set the hosts file
cat /home/vagrant/hosts > /etc/hosts
cat /home/vagrant/eth0 > /etc/network/interfaces.d/eth0
# cat /home/vagrant/eth0 > /etc/network/interfaces.d/eth0

# move the ansible ssh keys and set permissions
# ansible will be provisioned on all machines
useradd -m -s /bin/bash ansible
usermod -aG sudo ansible
echo -e "ansible\nansible" | passwd ansible
mkdir -p /home/ansible/.ssh
cat /home/vagrant/ansible.pub >> /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/
chmod 700 /home/ansible/.ssh/*

sed -i -e 's/iface eth0*//' -e 's/address *//' -e 's/netmask *//' -e 's/gateway *//' -e 's/dns-nameserv*//' /etc/network/interfaces

shutdown +0 -r