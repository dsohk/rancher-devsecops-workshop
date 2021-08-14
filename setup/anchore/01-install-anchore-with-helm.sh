#! /bin/bash

helm repo add anchore https://charts.anchore.io
helm repo update

helm install anchore anchore/anchore-engine \
  --create-namespace \
  -n anchore


