#!/bin/bash

usage() {
  echo "<argo-autosync-all.sh> <on|off>"
  exit 1
}

if [ "${1}" != "on" ] && [ "${1}" != "off" ]; then
  echo "Specify on or off"
  echo "# Applications with autosync enabled:"
  kubectl get application -A -o json | jq -r '.items[] | select(.spec.syncPolicy.automated != null) | "\(.metadata.namespace)/\(.metadata.name)"'
  #| jq -r '.items[] | select(.spec.syncPolicy.automated != null) | .metadata.name'
  echo
  echo "# Applications with autosync DISABLED:"
  kubectl get application -A -o json | jq -r '.items[] | select(.spec.syncPolicy.automated == null) | "\(.metadata.namespace)/\(.metadata.name)"'
  #| jq -r '.items[] | select(.spec.syncPolicy.automated == null) | .metadata.name'
fi

kubectl get application -A --no-headers | while read ns app x; do
  if [ "${1}" == "on" ]; then
    echo "Enabling autosync for ${ns}/${app}"
    kubectl patch application "${app}" -n "${ns}" --type='json' -p='[{"op": "replace", "path": "/spec/syncPolicy/automated", "value": { "prune": true, "selfHeal": true}}]'
  fi

  if [ "${1}" == "off" ]; then
    echo "Disabling autosync for ${ns}/${app}"
    kubectl patch application "${app}" -n "${ns}" --type='json' -p='[{"op": "replace", "path": "/spec/syncPolicy/automated", "value": null}]'
  fi
done
