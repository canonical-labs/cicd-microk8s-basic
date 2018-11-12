#!/usr/bin/env bash

set -u  # fail on undeclared variables

# Grab the directory of the scripts, in case the script is invoked from a different path
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Useful routines in common.sh
. "${SCRIPTS_DIR}/common-cicd.sh"
CONFIG_DIR=${CONFIG_DIR:-"${SCRIPTS_DIR}/configs"}

printf "\nDeleting the PV Claim '${PVC_NAME}':\n"
kubectl delete -f ${CONFIG_DIR}/pv_claim.yaml &>/dev/null
kubectl get pvc

printf "\nDeleting the Persistent Volume '${PV_NAME}':\n"
kubectl delete -f ${CONFIG_DIR}/persistent_volume.yaml &>/dev/null
kubectl get pv

printf "\nDeleting the Storage Class '${SNAME}':\n"
kubectl delete -f ${CONFIG_DIR}/storage_class.yaml &>/dev/null
kubectl get sc 
