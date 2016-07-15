#!/bin/bash

set -e -x 

add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
apt-get -qq update
apt-get -y install lxd htop tmux jq 
newgrp lxd
lxd init --auto --storage-backend=dir && (
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
    dpkg-reconfigure -p medium lxd
) || true

test -f ssh_keys/insecure || ssh-keygen -N "" -f ssh_keys/insecure

lxc list -c n | grep -q fedora || lxc launch images:fedora/23/amd64 fedora

# https://bugzilla.redhat.com/show_bug.cgi?id=1224908
lxc exec fedora -- dnf install -y openssh-server | tee
lxc exec fedora -- systemctl start sshd
lxc exec fedora -- echo "root:12345678" | chpasswd
lxc exec fedora -- mkdir -p /root/.ssh && chmod og-rwx /root/.ssh
lxc file push --uid=0 --gid=0 --mode=0400 ssh_keys/insecure.pub fedora/root/.ssh/authorized_keys

IP=$(lxc list fedora --format=json | jq '.[0].state.network.eth0.addresses[] | select(.family=="inet") | .address' | tr -d \")

ssh root@$IP -i ssh_keys/insecure dnf -y upgrade 

