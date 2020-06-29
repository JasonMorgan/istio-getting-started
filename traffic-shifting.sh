#!/bin/bash

## If needed:
kubectl apply -f istio-1.6.3/samples/bookinfo/networking/virtual-service-all-v1.yaml
kubectl apply -f istio-1.6.3/samples/bookinfo/networking/virtual-service-reviews-50-v3.yaml
kubectl get virtualservice reviews -o yaml
kubectl apply -f istio-1.6.3/samples/bookinfo/networking/virtual-service-reviews-v3.yaml

## Cleanup
kubectl delete -f istio-1.6.3/samples/bookinfo/networking/virtual-service-all-v1.yaml
