#!/bin/bash
sudo apt update -y
sudo apt install -y ansible git
git clone git@github.covm:kishore14194/cicd-ansible.git /home/ubuntu/ansible-setup
