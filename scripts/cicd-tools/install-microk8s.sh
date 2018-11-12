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
  # Ensure kubernetes is running properly
  echo "Checking kube-system status until valid response.."
  sleep 6 ## TODO: better way to test the port is up..
  until [[ `kubectl get pods -n=kube-system -o jsonpath='{.items}'| grep '\[\]'` == "[]" ]] ; do
    echo ".. Sleeping 3 seconds"
  done
}

# Ensure KUBECONFIG is in .bashrc so that other kubernetes tools can use it
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
microk8s.enable dns
microk8s.enable dashboard
# microk8s.enable storage
ensure_kubeconfig
# This gets around an open issue with all-in-one installs
iptables -P FORWARD ACCEPT
