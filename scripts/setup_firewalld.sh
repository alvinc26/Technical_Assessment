#!/bin/bash

user_acc_name=ec2-user
passwd_path_user=/home/${user_acc_name}/passwd_${user_acc_name}.txt

echo "Starting firewall-cmd service"
sudo -S systemctl enable firewalld < ${passwd_path_user}
sudo -S systemctl start firewalld < ${passwd_path_user}
echo "Adding ports"
sudo -S firewall-cmd --permanent --add-port={80/tcp,443/tcp,22/tcp} < ${passwd_path_user}
sudo -S firewall-cmd --reload < ${passwd_path_user}

sudo -S systemctl daemon-reload < ${passwd_path_user}