#!/bin/bash

##################################################################################
## If you plan on re-creating the stack frequently, or want to fix the version of
## the snaps you are running, then consider downloading them.
##
## install-microk8s will use the cached versions if they exist
##################################################################################

# Grab the directory of the scripts, in case the script is invoked from a different path
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Useful routines in common.sh
. "${SCRIPTS_DIR}/common-cicd.sh"
SNAPS_DIR="${SCRIPTS_DIR}/snaps"

# If you want a particular version, you can look at info, eg 'snap info microk8s'
# From that info, you can do something like 'snap download microk8s --channel=<>'
mkdir -p "${SNAPS_DIR}"
cd "${SNAPS_DIR}"
snap download core
snap download kubectl
snap download microk8s
