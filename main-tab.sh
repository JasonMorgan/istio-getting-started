#!/bin/bash

. setup_shell.sh

# 01

bat ./01_install.sh
pushd istio-$REL
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo
kubectl label namespace default istio-injection=enabled
istioctl analyze
popd

# 02



kubectl api-resources --api-group networking.istio.io
#_ECHO_# Check LB
kubectl get svc istio-ingressgateway -n=istio-system

#Install bookinfo application

bat -l yaml istio-$REL/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f istio-$REL/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl get pods
kubectl get svc

# Install Istio Gateway and VirtualService
# gateway says: accepting all traffic from port 80 on the load balancer;  virtual service says: i associate myself with that gateway. if any of that traffic matches these rules, redirect the traffic to these hosts/ports, where a host is a service
yqc -d 0 istio-$REL/samples/bookinfo/networking/bookinfo-gateway.yaml
yqc -d 1 istio-$REL/samples/bookinfo/networking/bookinfo-gateway.yaml
# kubectl apply -f istio-$REL/samples/bookinfo/networking/bookinfo-gateway.yaml


kubectl apply -f istio-$REL/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f istio-$REL/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f istio-$REL/samples/bookinfo/networking/destination-rule-all.yaml

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
# export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "If you're cluster is on AWS browse to:"
echo http://$GATEWAY_URL/productpage

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export INGRESS_HOST=127.0.0.1
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "If you're cluster is docker for desktop browse to:"
echo http://$GATEWAY_URL/productpage

# 03

# Open Kali in another tab

# 04

kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml

## Tour around the objects
kubectl get virtualservices -o yaml
kubectl get destinationrules -o yaml

## Checkout the page, no stars

## Route2

kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml

kubectl get virtualservice reviews
kubectl get virtualservice reviews -o yaml

## Log in as jason, stars come back, logout
### Logging in involves putting in a username and no password
### Worth it to install a page refresher
### After all these steps go checkout the console
### For more details: https://istio.io/latest/docs/tasks/traffic-management/request-routing/#understanding-what-happened





kubectl api-resources --api-group networking.istio.io
#_ECHO_# Check LB
kubectl get svc istio-ingressgateway -n=istio-system

#Install bookinfo application
bat -l yaml istio-$REL/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f istio-$REL/samples/bookinfo/platform/kube/bookinfo.yaml
k get pods
k get svc

# Install Istio Gateway and VirtualService
# gateway says: accepting all traffic from port 80 on the load balancer;  virtual service says: i associate myself with that gateway. if any of that traffic matches these rules, redirect the traffic to these hosts/ports, where a host is a service
yqc -d 0 istio-$REL/samples/bookinfo/networking/bookinfo-gateway.yaml
yqc -d 1 istio-$REL/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f istio-$REL/samples/bookinfo/networking/bookinfo-gateway.yaml

# Install DestinationRules
# DestinationRule: Next level of granularity after Virtual Service. For a given Kubernetes Service,
bat -l yaml istio-$REL/samples/bookinfo/networking/destination-rule-all.yaml
kubectl apply -f istio-$REL/samples/bookinfo/networking/destination-rule-all.yaml

#_ECHO_OFF
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
#_ECHO_ON

#_ECHO_# Browse to:
echo http://$GATEWAY_URL/productpage

#_ECHO_# Start Kiali Dashboard (admin/admin)
istioctl dashboard kiali &

#_ECHO_# Route1
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml

#_ECHO_# Tour around the objects

kubectl get virtualservices reviews -o yaml |bat -l yaml


#_ECHO_# Checkout the page, no stars

#_ECHO_# Route2

kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml

kubectl get virtualservice reviews -o yaml  |bat -l yaml

#_ECHO_# Log in as jason, stars come back, logout
### Logging in involves putting in a username and no password
### Worth it to install a page refresher
#_ECHO_# After all these steps go checkout the console
### For more details: https://istio.io/latest/docs/tasks/traffic-management/request-routing/#understanding-what-happened

## Cleanup
### Skip this by default
# kubectl delete -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml
