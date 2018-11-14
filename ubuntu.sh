#!/usr/bin/env bash

# Update apt-get
apt-get -y update

# Update Ubuntu
DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y -u -o Dpkg::Options::="--force-confdef"
apt-get -y dist-upgrade
