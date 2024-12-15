#!/bin/bash

user_acc_name=ec2-user
passwd_path_user=/home/${user_acc_name}/passwd_${user_acc_name}.txt

echo "Enabling sshd service"
sudo -S systemctl enable sshd < ${passwd_path_user}
sudo -S systemctl start sshd < ${passwd_path_user}

sudo -S systemctl daemon-reload < ${passwd_path_user}