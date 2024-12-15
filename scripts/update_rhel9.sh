#!/bin/bash

echo "Updating RHEL 9"
sudo dnf update -y

echo "Installing firewalld"
sudo dnf install firewalld -y

echo "Installing bzip2"
sudo dnf install bzip2 -y

echo "Installing wget"
sudo dnf install wget -y

sudo systemctl daemon-reload