#!/bin/bash

echo "# Applications with autosync enabled:"
kubectl get application -A -o json | jq -r '.items[] | select(.spec.syncPolicy.automated != null) | "\(.metadata.namespace)/\(.metadata.name)"'
#| jq -r '.items[] | select(.spec.syncPolicy.automated != null) | .metadata.name'

echo

echo "# Applications with autosync DISABLED:"
kubectl get application -A -o json | jq -r '.items[] | select(.spec.syncPolicy.automated == null) | "\(.metadata.namespace)/\(.metadata.name)"'
#| jq -r '.items[] | select(.spec.syncPolicy.automated == null) | .metadata.name'
