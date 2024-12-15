#!/bin/bash

echo "Installing Ansible using Python for OS hardening"
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible

sudo systemctl daemon-reload