#!/bin/bash

# In case the script is invoked from a different directory, grab mine
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Useful routines in common.sh
. "${SCRIPTS_DIR}/common.sh"

exit_no_multipass

# Only clean the VM if it exists
if vm_exists ${SINGLE_VM_NAME} ; then
  multipass delete ${SINGLE_VM_NAME}
  multipass purge
  info "${SINGLE_VM_NAME} exists. Deleting and purging."
else
  info "${SINGLE_VM_NAME} doesn't exist. Ignoring clean command."
fi
