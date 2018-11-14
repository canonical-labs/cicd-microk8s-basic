#!/bin/bash

######################
## Common Variables ##
######################

VM_IMAGE=${VM_IMAGE:-"bionic"}
SINGLE_VM_NAME=${SINGLE_VM_NAME:-"cicd-single"}
HOME=${HOME:-"temp"}
STORAGE_SRC=${STORAGE_SRC:-"${HOME}/.canonical/labs/cicd/storage"}
STORAGE_DST=${STORAGE_DST:-"/canonical/labs/cicd/storage"}
## CICD_SCRIPTS_DST is the location in the VM to place the scripts. The SRC is defined
## inside of the script mounting the volume (ie create-single-vm.sh)
CICD_SCRIPTS_DST=${CICD_SCRIPTS_DST:-"/canonical/labs/cicd/scripts"}

# colors for printing
RED='\033[1;31m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color


######################
## Common Functions ##
######################

function info() {
  printf "${BLUE}${@}${NC}\n"
}

function error() {
  printf "${RED}${@}${NC}\n"
}

# Print the error ($2) and exit with status code ($1)
function exit_error() {
  error $@
  exit 1
}


# Exit if multipass doesn't exist
function exit_no_multipass() {
  if ! hash multipass &>/dev/null; then
    exit_error "Please install mutlipass and ensure it is on your path."
  fi
}

# Return true if the VM exists, false otherwise
function vm_exists() {
  multipass list | grep $1 &>/dev/null
  return $?
}

# Ensure the source directory exists.
function ensure_host_storage() {
  mkdir -p ${STORAGE_SRC}
}
