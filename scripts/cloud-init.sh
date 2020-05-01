#!/usr/bin/env bash

set -ex

DATA_SOURCE=/var/lib/cloud/seed/nocloud-net
META_DATA=/tmp/vagrant/cloud-init/nocloud-net/meta-data
USER_DATA=/tmp/vagrant/cloud-init/nocloud-net/user-data

# confirm this is a debian box
[[ ! -f /etc/debian_version ]] && exit 1

apt install cloud-init -y

# write cloud-init files
mkdir -p $DATA_SOURCE
cp $META_DATA $DATA_SOURCE/ || exit 1
cp $USER_DATA $DATA_SOURCE/ || exit 1

reboot # with cloud init