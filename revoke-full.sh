#!/usr/bin/env bash

# Find script directory
sd=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
# Load variables
source $sd/variables.sh

name=$1

if [ "$name" = "" ]; then
  echo "Usage: make-config.sh name"
  exit;
fi

cd $CA_DIR
source vars

# And error ending in "ending in error 23" is expected
$sd/revoke-full $name

# Install the revocation files
cp $KEY_DIR/crl.pem /etc/openvpn

# Configure the server to check the client revocation list. This should only be done once
if [ $(grep -R 'crl-verify crl.pem' /etc/openvpn/server.conf | wc -l) -eq 0 ]; then
  echo "crl-verify crl.pem" >> /etc/openvpn/server.conf
  systemctl restart openvpn@server
fi
