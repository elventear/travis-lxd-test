#!/bin/bash

set -e -x 

ssh -v root@$(cat FEDORA_IP.txt) -i ssh_keys/insecure dnf -y upgrade 
ssh -v root@$(cat FEDORA_IP.txt) -i ssh_keys/insecure dnf -y install htop tmux  

