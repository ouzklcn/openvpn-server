#!/usr/bin/env bash
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Find script directory
sd=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
# Load variables
source $sd/variables.sh

name=$1

if [ "$name" = "" ]; then
  echo "Usage: download-ovpn.sh name"
  exit;
fi

# Check if openvpn file exists for the user
if [ ! -f ${CONFIG_FILES_DIR}/${name}.ovpn ]; then
  echo "No vpn configuration found for user with name: " $name
  exit;
fi

cat ${CONFIG_FILES_DIR}/${name}.ovpn

