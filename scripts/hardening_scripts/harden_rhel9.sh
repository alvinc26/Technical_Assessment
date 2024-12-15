#!/bin/bash

user_acc_name=ec2-user

echo "Creating random password for ${user_acc_name}"
password=$(sudo cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 24 | head -n24 | head -n1)
passwd_path_user=/home/${user_acc_name}/passwd_${user_acc_name}.txt
sudo touch ${passwd_path_user}
sudo chown ${user_acc_name} ${passwd_path_user}
sudo chmod 666 ${passwd_path_user}
echo ${password} > ${passwd_path_user}
sudo chmod 664 ${passwd_path_user}
echo "Changing password for ${user_acc_name}"
echo ${password} | sudo passwd --stdin ${user_acc_name}

echo "Creating random password for bootloader password"
bootloader_password=$(sudo cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 24 | head -n24 | head -n1)
passwd_path_bootloader=/home/${user_acc_name}/passwd_bootloader.txt
sudo touch ${passwd_path_bootloader}
sudo chown ${user_acc_name} ${passwd_path_bootloader}
sudo chmod 666 ${passwd_path_bootloader}
echo ${bootloader_password} > ${passwd_path_bootloader}
sudo chmod 664 ${passwd_path_bootloader}

ansible_root_path=/home/${user_acc_name}/.ansible
ansible_harden_rhel9_path=${ansible_root_path}/harden_rhel9.yml
echo "Installing rhel 9 hardening yml"
ansible-galaxy collection install trippsc2.cis

echo "Creating ansible playbook to call rhel9_cis role"
sudo touch ${ansible_harden_rhel9_path}
sudo chmod 707 ${ansible_harden_rhel9_path}
sudo cat <<EOF > ${ansible_harden_rhel9_path}
- hosts: localhost
  roles:
    - { role: trippsc2.cis.rhel9 }
  become: true
  become_user: root
  vars:
    rhel9cis_bootloader_password: "{{ bootloader_password }}"
    ansible_become_password: "{{ password }}"
    ansible_user: "{{ user }}"
    ansible_password: "{{ password }}"
EOF

ansible-playbook -i "localhost" ${ansible_harden_rhel9_path} --extra-vars "bootloader_password=${bootloader_password} password=${password} user=${user_acc_name}"

sudo -S chmod 744 ${ansible_harden_rhel9_path} < ${passwd_path_user}