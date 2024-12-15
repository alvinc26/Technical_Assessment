#!/bin/bash

user_acc_name=ec2-user
passwd_path_user=/home/${user_acc_name}/passwd_${user_acc_name}.txt

echo "Installing nginx"
sudo -S dnf install nginx -y < ${passwd_path_user}
echo "Update nginx if any"
sudo -S dnf update nginx -y < ${passwd_path_user}
echo "Enable nginx service"
sudo -S systemctl enable nginx < ${passwd_path_user}
echo "Start nginx service"
sudo -S systemctl start nginx < ${passwd_path_user}

sudo -S systemctl daemon-reload < ${passwd_path_user}