#!/bin/bash

# TODO: Fix to work with multiple sources - rewrite in python perhaps

kubectl get apps -o=custom-columns=NAME:.metadata.name,"SYNC STATUS":.status.sync.status,"HEALTH STATUS":.status.health.status,"OPERATIONSTATE PHASE":.status.operationState.phase,"SYNC WAVE":".metadata.annotations.argocd\.argoproj\.io/sync-wave","BRANCH":".spec.source.targetRevision","DELETING":".metadata.deletionTimestamp" #--sort-by ".metadata.annotations.argocd\.argoproj\.io/sync-wave" $@
