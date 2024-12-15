packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "rhel" {
  ami_name      = "hardened-packer-linux-rhel9-nginx-{{ timestamp }}"
  instance_type = "t2.micro"
  region        = "ap-southeast-1"
  source_ami_filter {
    filters = {
      image-id            = "ami-0b748249d064044e8" # RHEL 9 AMI ID from AWS
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }
  ssh_username = "ec2-user"
}

build {
  name = "packer-linux-rhel-nginx"
  sources = [
    "source.amazon-ebs.rhel"
  ]

  provisioner "shell" {
    script            = "scripts/update_user.sh"
    expect_disconnect = true
    pause_after       = "60s"
  }

  provisioner "shell" {
    script = "scripts/update_rhel9.sh"
  }

  provisioner "shell" {
    script = "scripts/install_ansible.sh"
  }

  provisioner "shell" {
    script = "scripts/hardening_scripts/harden_rhel9.sh"
  }

  provisioner "shell" {
    script = "scripts/setup_firewalld.sh"
  }

  provisioner "shell" {
    script = "scripts/setup_ssh.sh"
  }

  provisioner "shell" {
    script = "scripts/install_nginx.sh"
  }

  provisioner "shell" {
    script = "scripts/generate_cert.sh"
  }

  provisioner "shell" {
    script = "scripts/setup_nginx.sh"
  }

  provisioner "shell" {
    script = "scripts/oscap_check_rhel9.sh"
  }

  provisioner "shell" {
    script = "scripts/hardening_scripts/harden_nginx.sh"
  }
}