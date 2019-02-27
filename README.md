# Local CICD Pipelines on Ubuntu Kubernetes

## Introduction

The advent of Kubernetes has benefitted CI/CD initiatives greatly - it gives the tools and components commonly used in CI/CD a known set of APIs to work with. These Kubernetes APIs can be used for their own deployment, as well as leveraged as part of your service or application.

The reference examples in this repository will focus on a couple of deployment models:

1. Deploy everything in a single server
2. Deploy everything in a distributed set of servers (_not yet started_)
3. For both of the above we will start simply, using one or more VMs. The benefit is this approach is that many heterogenous environments provide the ability to launch VMs - from laptop to private clouds to public clouds.

We'll describe the initial set of components that the examples deploy, along with a list of the complete set of components available in this repo.

# All-in-One

For this reference example, we'll deploy the entire set of components onto a single kubernetes cluster, and use that cluster as our dev cluster for deploying a hello-world application.  This is useful for testing the initial capabilities of an application - from deployment / configuration-as-code mechanisms to functional / acceptance tests against the application.

## Setup Instructions

The example leverages several scripts. The variables in the scripts can be overwritten without changing the scripts themselves. We'll start with a summary of the instructions to follow to setup the software. Then the next section describes the variables in more detail.

### Installation Summary

Here's a summary of the steps. More detail will come in following sections. The emphasis here is on the bare minimum set of steps.

```
#-- HOST --#
clone https://github.com/canonical-labs/cicd-microk8s-basic.git cicd
cd cicd
cicd/scripts/mp/create-single-vm.sh
cicd/scripts/mp/ssh-single-vm.sh

#--  VM  --#
sudo /canonical/labs/cicd/scripts/install-microk8s.sh
/canonical/labs/cicd/scripts/add-local-storage.sh
/canonical/labs/cicd/scripts/add-helm.sh
/canonical/labs/cicd/scripts/add-gitlab.sh
/canonical/labs/cicd/scripts/add-jenkins.sh
(tbd) /canonical/labs/cicd/scripts/add-nexus.sh
(tbd) /canonical/labs/cicd/scripts/add-spinnaker.sh

#-- OPTIONAL --#
# if you plan on doing install-all a lot - strongly advise downloading snaps
# Do this before install-microk8s.sh to get the full benefit.
download-snaps.sh

```


### Key variables

**Please note**: *it's possible that the values in these tables drift from what is in the source files. Please review source files to confirm defaults*

| Variable | Default | Description | File |
|---|---|---|---|
| VM_IMAGE | bionic | The version of Ubuntu to use. "bionic" is Ubuntu 18.04 | scripts/mp/common.sh |
|  SINGLE_VM_NAME | cicd-single  | The name of the vm for multipass. ```multipass list``` will show the status of this VM. | scripts/mp/common.sh |
| HOME | Defined by ENV, or "temp" | Your home directory. Used by MOUNT_SRC. Most linux systems define the HOME environment variable. | scripts/mp/common.sh |
| MOUNT_SRC | $HOME/.canonical/labs/cicd | The location on the host of the directory to use inside the VM. All assets (e.g. container registry) will be stored here. | scripts/mp/common.sh |
| MOUNT_DST | /canonical/labs/cicd  | The location inside of the VM of the mounted host directory. This will be forwarded to microk8s/kubernetes for use as a persistent volume. | scripts/mp/common.sh |
| ---  | ---  | --- | --- |


# Distributed

(__TBD__)
