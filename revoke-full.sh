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
  echo "Usage: revoke-full.sh name"
  exit;
fi

# Check if openvpn file exists for the user
if [ ! -f ${CONFIG_FILES_DIR}/${name}.ovpn ]; then
  echo "No vpn configuration found for user with name: " $name
  exit;
fi

cd $CA_DIR
source vars

# And error ending in "ending in error 23" is expected
./revoke-full $name

# Install the revocation files
cp $KEY_DIR/crl.pem /etc/openvpn

# Configure the server to check the client revocation list. This should only be done once
if [ $(grep -R 'crl-verify crl.pem' /etc/openvpn/server.conf | wc -l) -eq 0 ]; then
  echo "crl-verify crl.pem" >> /etc/openvpn/server.conf
  systemctl restart openvpn@server
fi

# Remove ovpn file
rm -rf ${CONFIG_FILES_DIR}/${name}.ovpn

# Remove key files
rm -rf ${KEY_DIR}/${name}.*
