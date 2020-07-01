#!/bin/bash

kubectl -n istio-system get svc prometheus
kubectl -n istio-system get svc grafana

istioctl dashboard prometheus

## Queries
### istio_requests_total
### istio_requests_total{destination_service="productpage.default.svc.cluster.local"}
### istio_requests_total{destination_service="reviews.default.svc.cluster.local", destination_version="v3"}
### rate(istio_requests_total{destination_service=~"productpage.*", response_code="200"}[5m])

## Checkout grafana
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 &
## Browse to http://localhost:3000/dashboard/db/istio-mesh-dashboard
## http://localhost:3000/dashboard/db/istio-service-dashboard
## http://localhost:3000/dashboard/db/istio-workload-dashboard
### Ideally have something generating traffic into the mesh
