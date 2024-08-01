#!/bin/bash

# TODO: Fix to work with multiple sources - rewrite in python perhaps

kubectl get apps  -o go-template='
{{- printf "NAME\tSYNC STATUS\tHEALTH STATUS\tOPERATIONSTATE PHASE\tSYNC WAVE\tBRANCH/REV(s)\tDELETING\n" -}}
{{- range .items -}}
{{-   $name := .metadata.name -}}
{{-   $syncStatus := .status.sync.status -}}
{{-   $healthStatus := .status.health.status -}}
{{-   $opStatePhase := "" -}}
{{-   if .status.operationState.phase -}}
{{-     $opStatePhase = .status.operationState.phase -}}
{{-   end -}}
{{-   $syncWave := "" -}}
{{-   if index .metadata.annotations "argocd.argoproj.io/sync-wave" -}}
{{-     $syncWave = index .metadata.annotations "argocd.argoproj.io/sync-wave" -}}
{{-   end -}}
{{-   $branch := "" -}}
{{-   $branches := "" -}}
{{-   $sep := "" -}}
{{-   range $index, $b := .spec.sources -}}
{{-     if $index -}}
{{-       $sep = ", " -}}
{{-     end -}}
{{-     $branches = printf "%s%s%s" $branches $sep $b.targetRevision -}}
{{-   end -}}
{{-   if .spec.source.targetRevision -}}
{{-     $branches = .spec.source.targetRevision -}}
{{-   end -}}
{{-   $deleting := "" -}}
{{-   if $deleting -}}
{{-     $deleting = .metadata.deletionTimestamp -}}
{{-   end  -}}
{{   printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $name $syncStatus $healthStatus $opStatePhase $syncWave $branches $deleting  -}}
{{- end -}}
' | column -t -s$'\t'


exit

# -o=custom-columns=NAME:.metadata.name,"SYNC STATUS":.status.sync.status,"HEALTH STATUS":.status.health.status,"OPERATIONSTATE PHASE":.status.operationState.phase,"SYNC WAVE":".metadata.annotations.argocd\.argoproj\.io/sync-wave","BRANCH":".spec.source.targetRevision","DELETING":".metadata.deletionTimestamp"
 #--sort-by ".metadata.annotations.argocd\.argoproj\.io/sync-wave" $@
