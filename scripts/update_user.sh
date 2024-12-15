#!/bin/bash

user_acc_name=ec2-user

echo "Changing ${user_acc_name} permission"
sudo usermod -aG wheel ${user_acc_name}
echo "${user_acc_name} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${user_acc_name}
sudo chmod 0440 /etc/sudoers.d/${user_acc_name}

echo "Restarting VM"
sudo init 6