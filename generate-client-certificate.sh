#!/usr/bin/env bash

# Find script directory
sd=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
# Load variables
source $sd/variables.sh
# Change to script directory
cd $sd


name=$1

if [ "$name" = "" ]; then
  echo "Usage: generate-client-certificate.sh name"
  exit;
fi

cd $CA_DIR
source vars
$sd/build-key.sh $name
