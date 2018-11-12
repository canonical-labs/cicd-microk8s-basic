#!/bin/bash

######################
## Common Variables ##
######################

# colors for printing
RED='\033[1;31m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# Storage names and sizing
## Key Variables, with defaults, that can be overwritten
SNAME=${SNAME:-"local.storage"}
SPATH=${SPATH:-"/canonical/labs/cicd/storage/"}
# the node name for microk8s is the same as the host name .. could make more generic
# by fetching the node name field from kubectl get node
SNODE=${SNODE:-${HOSTNAME}}
PV_NAME=${PV_NAME:-"${SNAME}.pv"}
PV_MAX=${PV_MAX:-300Gi}
# Default the claim to be able to use the entire PV.
PVC_NAME=${PVC_NAME:-"${SNAME}.pvc"}
PVC_MAX=${PVC_MAX:-100Gi}
#PVC_MAX=${PVC_MAX:-${PV_MAX}}

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

# Ensure we run as root ..
function ensure_root() {
  if [[ $EUID -ne 0 ]]; then
      error "This script should run using sudo or as the root user"
      exit 1
  fi
}

# used primarily to run a cached file if it exists ..
function files_exist() {
  ls $1 &>/dev/null
  echo $?
}

# If a cached snap exists, use it, otherwise download from the Internet.
# If using confinement, channel has to be passed in, since it is assumed to be $2
function install_snap() {
  local snap_name=$1
  local snap_wildcard="${SCRIPTS_DIR}/snaps/${snap_name}*"
  local channel=${2:-""}
  local confinement=${3:-""}
  if [[ $(files_exist ${snap_wildcard}) == 0 ]]; then
    info "Install ${snap_name} ${confinement} from cache.."
    snap ack ${snap_wildcard}.assert
    snap install ${snap_wildcard}.snap ${confinement}
  else
    info "Install ${snap_name} ${channel} ${confinement} from Internet.."
    snap install ${snap_name} ${channel} ${confinement}
  fi
}
