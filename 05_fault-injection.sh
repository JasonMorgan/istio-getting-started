#!/bin/bash

## Based on the steps here: https://istio.io/latest/docs/tasks/traffic-management/fault-injection/

REL=$(curl -L -s https://api.github.com/repos/istio/istio/releases | \
                  grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/" | \
                  grep -v -E "(alpha|beta|rc)\.[0-9]$" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)

## If needed:
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml

## Inject a delay:
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-ratings-test-delay.yaml

k get virtualservices ratings -o yaml

### Logging in involves putting in a username and no password
### Only jason has the problem
### More details: https://istio.io/latest/docs/tasks/traffic-management/fault-injection/#understanding-what-happened\
### Fix with Traffic-shifting: https://istio.io/latest/docs/tasks/traffic-management/fault-injection/#fixing-the-bug
#### Only fixes reviews, ratings stays down.

### Cleanup (Optional)
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml
kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml

## Inject HTTP abort

kubectl apply -f istio-$REL/samples/bookinfo/networking/virtual-service-ratings-test-abort.yaml

### Now bookinfo loads with no ratings instantly because ratings returns an error


k get virtualservices ratings -o yaml

### Cleanup

kubectl delete -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml
