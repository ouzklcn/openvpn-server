#!/usr/bin/env bash
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi


# Update apt-get
apt-get -y update

# Update Ubuntu
DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y -u -o Dpkg::Options::="--force-confdef"
apt-get -y dist-upgrade
