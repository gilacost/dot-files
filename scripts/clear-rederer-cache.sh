#!/bin/sh
set -x

if ! [ -x `command -v gcloud` ]; then
    echo "error: install gcloud before using this script"
    exit 1
fi

NAMESPACE=$1

declare -a namespaces=("renderer-production" "renderer-staging");

if [[ ! " ${namespaces[@]} " =~ " ${NAMESPACE} " ]]; then
    if [[ -z  "$NAMESPACE" ]]; then
        NAMESPACE="empty string..."
    fi
    echo "${NAMESPACE} is not a valid namespace. Available namespaces are:"
    echo ${namespaces[@]} | tr " " "\n"
    exit 2
fi

gcloud container clusters get-credentials tboe-k8s --zone us-central1-a --project the-book-of-everyone
pods=($(kubectl get pods --namespace "${NAMESPACE}" | awk '{ print $1 }'))

read -p "Are you sure you want to clear ${NAMESPACE} cache? press enter to continue..."

for p in "${pods[@]}"
do
    echo "clearing cache for pod ${p} in namespace ${NAMESPACE}"
    kubectl exec --namespace "${NAMESPACE}" "${p}" -- rm -rf /tmp/renderer-cache
done
