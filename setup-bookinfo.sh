#!/bin/bash

kubectl apply -f istio-1.6.3/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f istio-1.6.3/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f istio-1.6.3/samples/bookinfo/networking/destination-rule-all.yaml

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
# export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "If you're cluster is on AWS browse to:"
echo http://$GATEWAY_URL/productpage