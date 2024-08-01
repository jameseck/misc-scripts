#!/bin/bash

kubectl get application -A -o json | \
  jq -r '["NAME", "SYNC", "HEALTH"], (.items[] | [.metadata.name, .status.sync.status, .status.health.status]) | join(" ")' | \
  column -t
