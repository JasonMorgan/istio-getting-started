#!/bin/bash

REL=$(curl -L -s https://api.github.com/repos/istio/istio/releases | \
                  grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/" | \
                  grep -v -E "(alpha|beta|rc)\.[0-9]$" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)

## If needed:
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml

## Traffic shift
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-reviews-50-v3.yaml
kubectl get virtualservice reviews -o yaml
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-reviews-v3.yaml

## Cleanup
kubectl delete -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml
