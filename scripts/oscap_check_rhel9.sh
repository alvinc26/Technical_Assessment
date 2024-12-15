#!/bin/bash

user_acc_name=ec2-user
passwd_path_user=/home/${user_acc_name}/passwd_${user_acc_name}.txt
password=$(sudo -S cat ${passwd_path_user} < ${passwd_path_user})

echo "Installing OSCAP"
echo ${password} | sudo -S dnf install openscap-scanner -y

echo "Installing SCAP Security Guide (SSG)"
echo ${password} | sudo -S dnf install scap-security-guide -y

echo "Downloading rhel9 oval xml"
wget -O - https://www.redhat.com/security/data/oval/v2/RHEL9/rhel-9.oval.xml.bz2 | bzip2 --decompress > rhel-9.oval.xml

echo "Scanning system for vulnerabilities"
oscap oval eval --report rhel9_vulnerability.html rhel-9.oval.xml