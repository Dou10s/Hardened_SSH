#!/bin/bash



# the below is to provision users with their keys on BASE boxes only
# the hardened boxes use ansible instead
# for name in larry curly moe
# do
#    useradd -m $name
#    echo -e "test\ntest" | passwd $name
#    # setting local ssh certs
#    mv /home/vagrant/certs/$name /home/$name/.ssh
#    cat /home/$name/.ssh/id_rsa.pub >> /home/$name/.ssh/authorized_keys
# done

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

# set the ansible public key
cat /home/vagrant/ansible.pub >> /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/
chmod 700 /home/ansible/.ssh/*

mv /home/vagrant/sshconfig/* /etc/ssh/
chown -R root:root /etc/ssh
chmod 644 /etc/ssh/*
chmod 600 /etc/ssh/ssh_host_rsa_key

# fix the interface
sed -i -e 's/iface eth0*//' -e 's/address *//' -e 's/netmask *//' -e 's/gateway *//' -e 's/dns-nameserv*//' /etc/network/interfaces

#deluser vagrant --remove-home

shutdown +0 -r