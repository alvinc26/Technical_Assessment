#!/bin/bash

user_acc_name=ec2-user
passwd_path_user=/home/${user_acc_name}/passwd_${user_acc_name}.txt

cert_path="/etc/nginx/ssl"
cert_name="example"
days_valid=365
subject="/C=SG/ST=Singapore/L=Singapore/O=TEST/OU=TEST/CN=example.com"

sudo -S mkdir -p ${cert_path} < ${passwd_path_user}

echo "Generating private key"
sudo -S openssl genrsa -out ${cert_path}/${cert_name}.key 4096 < ${passwd_path_user}

echo "Generating cert"
sudo -S openssl req -new -x509 -key ${cert_path}/${cert_name}.key -out ${cert_path}/${cert_name}.crt -days ${days_valid} -subj "${subject}" < ${passwd_path_user}