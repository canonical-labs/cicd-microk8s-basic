#!/usr/bin/env bash

set -e  # exit immediately on error
set -u  # fail on undeclared variables

# In case the script is invoked from a different directory, grab mine
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Useful routines in common.sh
. "${SCRIPTS_DIR}/common.sh"

exit_no_multipass

# Only clean the VM if it exists
if vm_exists ${SINGLE_VM_NAME} ; then
  info "Deleting and purging VM '${SINGLE_VM_NAME}'."
  multipass delete ${SINGLE_VM_NAME}
  multipass purge
else
  info "The VM ${SINGLE_VM_NAME} does **not** exist."
fi
