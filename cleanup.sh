cd istio-1.6.3
samples/bookinfo/platform/kube/cleanup.sh
istioctl manifest generate --set profile=demo | kubectl delete -f -
kubectl delete namespace istio-system
