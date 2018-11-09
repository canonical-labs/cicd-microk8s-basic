#!/bin/bash

######################
## Common Variables ##
######################

VM_IMAGE=${VM_IMAGE:-"bionic"}
SINGLE_VM_NAME=${SINGLE_VM_NAME:-"cicd-single"}
HOME=${HOME:-"temp"}
MOUNT_SRC=${MOUNT_SRC:-"${HOME}/.canonical/labs/cicd"}
MOUNT_DST=${MOUNT_DST:-"/canonical/labs/cicd"}

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
function ensure_mount_src() {
  mkdir -p ${MOUNT_SRC}
}
