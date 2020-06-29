#!/bin/bash

pushd istio-1.6.3
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.6.3
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo
kubectl label namespace default istio-injection=enabled
istioctl analyze
popd