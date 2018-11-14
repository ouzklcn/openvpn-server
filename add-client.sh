#!/usr/bin/env bash
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Find script directory
sd=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
# Load variables
source $sd/variables.sh
# Change to script directory
cd $sd

name=$1

if [ "$name" = "" ]; then
  echo "Usage: add-client.sh name"
  exit;
fi

# Check if openvpn file exists for the user
if [ -f ${CONFIG_FILES_DIR}/${name}.ovpn ]; then
  echo "Existing vpn user found with name: " $name
  exit;
fi

# Generate a client certificate and key pair
$sd/generate-client-certificate.sh $name

# Make config
$sd/make-config.sh $name

