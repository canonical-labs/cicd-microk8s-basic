#!/usr/bin/env bash

set -e  # exit immediately on error
set -u  # fail on undeclared variables

# Grab the directory of the scripts, in case the script is invoked from a different path
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Useful routines in common.sh
. "${SCRIPTS_DIR}/common-cicd.sh"

# If snaps have been cached, then use those. Cached snaps facilitate restarts without
# Internet access. But patches won't be auto updated.
# Otherwise, install from the Internet.
function install_kubernetes() {
  install_snap microk8s --stable --classic

  # export the kubectl config file in case other tools rely on this
  mkdir -p $HOME/.kube
  microk8s.kubectl config view --raw > $HOME/.kube/config
  echo "Waiting for kubernetes core services to be ready.."
  microk8s.status --wait-ready
  sudo snap alias microk8s.kubectl kubectl
}

function install_addons() {
  microk8s.enable dns
  microk8s.enable dashboard
  microk8s.enable ingress
  microk8s.enable storage

  # Ensure kubernetes is running properly
  echo "Checking kubernetes addons are running.."

  until [[ `kubectl get pods --all-namespaces | grep -o 'ContainerCreating' | wc -l` == 0 ]] ; do
    echo "Waiting for kubernetes addon service pods to be ready, sleeping 10s  ("`kubectl get pods --all-namespaces | grep -o 'ContainerCreating' | wc -l`" not running)"
    sleep 10
  done
}

##
# Ensure KUBECONFIG is in .bashrc so that other kubernetes tools can use it
# NB: No longer needed (ensuring default lcoation ~/.kube/config instaed).. not used
#
function ensure_kubeconfig() {
  grep KUBECONFIG ${HOME}/.bashrc > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Skipping adding KUBECONFIG to ~/.bashrc, already exists"
  else
    echo "Adding KUBECONFIG to ~/.bashrc"
    printf "\n\nexport KUBECONFIG=/snap/microk8s/current/client.config\n\n" >> ${HOME}/.bashrc
  fi
}

ensure_root
install_kubernetes
install_addons

microk8s.kubectl config view --raw > $HOME/.kube/config
sudo snap alias microk8s.kubectl kubectl
