#!/usr/bin/env bash

set -e  # exit immediately on error
set -u  # fail on undeclared variables

##
## First install the jx tool if it doesn't exist
##

mkdir -p ~/.jx/bin
curl -L https://github.com/jenkins-x/jx/releases/download/v1.3.556/jx-linux-amd64.tar.gz | tar xzv -C ~/.jx/bin
PATH=$PATH:~/.jx/bin
## The following should already be in .bashrc via the cloud.init file
# echo 'export PATH=$PATH:~/.jx/bin' >> ~/.bashrc


##
## Now use jx to install jenkins into the k8s cluster
##
jx install --provider=kubernetes --on-premise
jx create quickstart -l go
