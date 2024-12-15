#!/bin/bash

user_acc_name=ec2-user
passwd_path_user=/home/${user_acc_name}/passwd_${user_acc_name}.txt
password=$(sudo -S cat ${passwd_path_user} < ${passwd_path_user})

ansible_root_path=/home/${user_acc_name}/.ansible
ansible_harden_nginx_path=${ansible_root_path}/harden_nginx.yml
echo "Installing nginx hardening yml"
ansible-galaxy collection install devsec.hardening

echo "Creating ansible playbook to call nginx hardening role"
echo ${password} | sudo -S touch ${ansible_harden_nginx_path}
echo ${password} | sudo -S chmod 707 ${ansible_harden_nginx_path}
echo ${password} | sudo -S cat <<EOF > ${ansible_harden_nginx_path}
- hosts: localhost
  roles:
    - name: devsec.hardening.nginx_hardening
  become: true
  become_user: root
  vars:
    ansible_become_password: "{{ password }}"
EOF

ansible-playbook -i "localhost" ${ansible_harden_nginx_path} --extra-vars "password=${password}"

echo ${password} | sudo -S chmod 744 ${ansible_harden_nginx_path}