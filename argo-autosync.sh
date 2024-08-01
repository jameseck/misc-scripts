#!/bin/bash

usage() {
  echo "<argo-autosync.sh> <on|off> <namespace> <application>"
  exit 1
}

if [ "${1}" != "on" ] && [ "${1}" != "off" ]; then
  echo "Specify on or off"
  usage
fi

if [ "$#" -ne 3 ]; then
  usage
fi

kubectl get ns "${2}" >/dev/null 2>&1
if [ "$?" -ne 0 ]; then
  echo Namespace \"$2}\" not found
  usage
fi

kubectl -n "${2}" get application "${3}" > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
  echo Application \"${3}\" in namespace \"${2}\" not found
  usage
fi

if [ "${1}" == "on" ]; then
  echo "Enabling autosync for ${2}/${3}"
  kubectl patch application "${3}" -n "${2}" --type='json' -p='[{"op": "replace", "path": "/spec/syncPolicy/automated", "value": { "prune": true, "selfHeal": true}}]'
fi

if [ "${1}" == "off" ]; then
  echo "Disabling autosync for ${2}/${3}"
  kubectl patch application "${3}" -n "${2}" --type='json' -p='[{"op": "replace", "path": "/spec/syncPolicy/automated", "value": null}]'
fi
