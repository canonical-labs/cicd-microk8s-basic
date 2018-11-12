#!/usr/bin/env bash

set -e  # exit immediately on error
set -u  # fail on undeclared variables

# Grab the directory of the scripts, in case the script is invoked from a different path
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Useful routines in common.sh
. "${SCRIPTS_DIR}/common-cicd.sh"
CONFIG_DIR=${CONFIG_DIR:-"${SCRIPTS_DIR}/configs"}
TEMPLATE_DIR=${TEMPLATE_DIR:-"${SCRIPTS_DIR}/templates"}

#####################################################################################
#
# Associate local storage with the kubernetes cluster. Initially used by the container
# registry, but most likely extended to other uses as well.
#
#####################################################################################

## Use the variables above to replace the template variables .. ie realize the real yamls
cp -f ${TEMPLATE_DIR}/*.yaml ${CONFIG_DIR}
sed -i'.orig' -e `echo s/\$\{\{storage.class.name}}/${SNAME}/g` ${CONFIG_DIR}/*.yaml
# NB: since the path may have '/', I'm using '^' as the sed delimiter
sed -i'.orig' -e `echo s^\$\{\{storage.path}}^${SPATH}^g` ${CONFIG_DIR}/*.yaml
sed -i'.orig' -e `echo s/\$\{\{storage.node}}/${SNODE}/g` ${CONFIG_DIR}/*.yaml
sed -i'.orig' -e `echo s/\$\{\{storage.capacity.pv}}/${PV_MAX}/g` ${CONFIG_DIR}/*.yaml
sed -i'.orig' -e `echo s/\$\{\{storage.capacity.pvc}}/${PVC_MAX}/g` ${CONFIG_DIR}/*.yaml
sed -i'.orig' -e `echo s/\$\{\{storage.pv.name}}/${PV_NAME}/g` ${CONFIG_DIR}/*.yaml
sed -i'.orig' -e `echo s/\$\{\{storage.pvc.name}}/${PVC_NAME}/g` ${CONFIG_DIR}/*.yaml

## Now we are ready to apply those yamls to kubernetes

kubectl create -f ${CONFIG_DIR}/storage_class.yaml
kubectl create -f ${CONFIG_DIR}/persistent_volume.yaml
kubectl create -f ${CONFIG_DIR}/pv_claim.yaml

## Print the information:
printf "\nGetting the Persistent Volume Status:\n"
kubectl get pv
#kubectl get pv ${PV_NAME}

printf "\nGetting the PV Claim Status:\n"
kubectl get pvc
#kubectl get pvc ${PVC_NAME}
