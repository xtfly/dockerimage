#!/bin/bash

PASS="123456"
echo "=> Setting a password to the root user"
echo "root:$PASS" | chpasswd

rm -f /etc/ssh/ssh_*_key
ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -A
sed -i "s/#*UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
sed -i "s/#*UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
sed -i "s/#*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

echo "========================================================================"
echo "You can now connect to this Archlinux container via SSH using:"
echo ""
echo "    ssh -p <port> root@<host>"
echo "and enter the root password '$PASS' when prompted"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"

echo "=> Starting SSHD"
/usr/bin/sshd -D
