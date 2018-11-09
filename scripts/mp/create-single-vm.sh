#!/bin/bash

# In case the script is invoked from a different directory, grab mine
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Useful routines in common.sh
. "${SCRIPTS_DIR}/common.sh"

# need mutlipass to launch the vm
exit_no_multipass

# Only create the VM if it doesn't exist
if vm_exists ${SINGLE_VM_NAME} ; then
  exit_error "${SINGLE_VM_NAME} already exists! Exiting."
else
  info "Creating ${SINGLE_VM_NAME}"
  multipass launch --name ${SINGLE_VM_NAME} ${VM_IMAGE}
  info "Mounting directory ${MOUNT_SRC} as ${MOUNT_DST}"
  ensure_mount_src
  multipass mount ${MOUNT_SRC} ${SINGLE_VM_NAME}:${MOUNT_DST}
fi
