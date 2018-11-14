#!/usr/bin/env bash

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

sudo cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${name}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${name}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-auth>')