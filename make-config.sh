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
usr=$(env | grep SUDO_USER | cut -d= -f 2)

if [ "$name" = "" ]; then
  echo "Usage: make-config.sh name"
  exit;
fi

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${name}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${name}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-auth>') \
    > ${CONFIG_FILES_DIR}/${name}.ovpn


# sed -i "s/group nogroup/group nobody/" ${OUTPUT_DIR}/${name}.ovpn
