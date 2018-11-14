#!/usr/bin/env bash
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

/vagrant/ubuntu.sh

/vagrant/openvpn.sh
