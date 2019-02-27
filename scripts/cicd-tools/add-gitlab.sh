#!/usr/bin/env bash

set -e  # exit immediately on error
set -u  # fail on undeclared variables

##
## Install GitLab  ..
##

## NB: This assumes the user adds the following to /etc/hosts in host (ie not VM)
##     <VM IP> http.gitlab.labs
##     <VM IP> gitlab.labs

helm install --name my-gitlab --set externalUrl=http://gitlab.labs/,gitlabRootPassword=pass1234 stable/gitlab-ce

# Ensure kubernetes is running properly
echo "Checking gitlab is running.."

until [[ `kubectl get pods --all-namespaces | grep -o 'ContainerCreating' | wc -l` == 0 ]] ; do
  echo "Waiting for all pods to be ready, sleeping 10s  ("`kubectl get pods --all-namespaces | grep -o 'ContainerCreating' | wc -l`" not running)"
  sleep 10
done


## TODO: There is most likely a setting to use NodePort .. pass that in above and remove
##       this command. The default is LoadBalancer, which doesn't make sense localy.
kubectl patch svc my-gitlab-gitlab-ce --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'

##
## Add the HTTP portion of gitlab to ingress
## TODO: Ports 22 and 443 are also mapped .. add those to enable other git protocols
echo "
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: gitlab-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: \"false\"
spec:
  rules:
  - host: http.gitlab.labs
    http:
      paths:
      - path: /
        backend:
          serviceName: my-gitlab-gitlab-ce
          servicePort: 80
" | kubectl apply -f -
