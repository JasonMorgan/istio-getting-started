#!/bin/bash
. setup_shell.sh

export NAMESPACE=default && istio-*/samples/bookinfo/platform/kube/cleanup.sh
istioctl manifest generate --set profile=demo | kubectl delete -f -
kubectl delete namespace istio-system
