#!/usr/bin/env bash

set -u  # fail on undeclared variables

PROXY_PORT=${PROXY_PORT:-8001}
LOCAL_ADDR=${LOCAL_ADDR:-'0.0.0.0'}

# Ensure the port is open .. otherwise assume this script has already executed
PORT_STATUS=`sudo netstat -tulpn | grep ${PROXY_PORT}` &>/dev/null
# PORT_STATUS has text if port open; hence fail -z; || clause will run
if ! [ -z "$PORT_STATUS" ] ; then
  echo "Port ${PROXY_PORT} is already used. Exiting"
  echo "Process: `echo ${PORT_STATUS} | cut -d ' ' -f 7`"
  exit 1
fi

# This command runs the proxy, allowing anyone to connect
kubectl proxy --port=${PROXY_PORT} --accept-hosts='^.*$' --address=${LOCAL_ADDR} &

# Use the token method for gaining access to the dashboard. This will require some
# setup for RBAC.

# Create/Update the service account (used in cluster role binding)
cat <<EOF | kubectl apply -f -
  kind: ServiceAccount
  apiVersion: v1
  metadata:
    name: microk8s-admin
    namespace: kube-system
EOF

# Create/Update the cluster role binding
cat <<EOF | kubectl apply -f -
  kind: ClusterRoleBinding
  apiVersion: rbac.authorization.k8s.io/v1beta1
  metadata:
    name: microk8s-admin
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
  - kind: ServiceAccount
    name: microk8s-admin
    namespace: kube-system
EOF

# Print the token that is needed to view the dashboard
printf "\nTo access the kubernetes dashboard, go to:\n"
printf "\n\t http://<EXTERNAL_IP>:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/ \n"
printf "\nCopy/paste this token into the kubernetes dashboard:\n"
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep microk8s-admin | awk '{print $1}') | grep token: | cut -d ":" -f 2 | xargs
