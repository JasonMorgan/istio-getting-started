#!/bin/bash
## Based on teh steps found here:https://istio.io/latest/docs/tasks/traffic-management/request-routing/

## Route1

REL=$(curl -L -s https://api.github.com/repos/istio/istio/releases | \
                  grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/" | \
                  grep -v -E "(alpha|beta|rc)\.[0-9]$" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)
                  
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

## Cleanup
### Skip this by default
kubectl delete -f istio-$REL/samples/bookinfo/networking/virtual-service-all-v1.yaml
