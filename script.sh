#!/bin/bash

set -e -x 

ssh -vvvv root@$(cat FEDORA_IP.txt) -i ssh_keys/insecure dnf -y upgrade 
ssh -vvvv root@$(cat FEDORA_IP.txt) -i ssh_keys/insecure dnf -y install htop tmux  

