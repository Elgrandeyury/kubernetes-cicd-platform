#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-platform-app}"
DEPLOYMENT="${DEPLOYMENT:-platform-app}"

kubectl -n "$NAMESPACE" rollout status deployment/"$DEPLOYMENT" --timeout=180s
kubectl -n "$NAMESPACE" get deployment,pods,service,ingress,hpa,pdb

READY=$(kubectl -n "$NAMESPACE" get deployment "$DEPLOYMENT" -o jsonpath='{.status.readyReplicas}')
DESIRED=$(kubectl -n "$NAMESPACE" get deployment "$DEPLOYMENT" -o jsonpath='{.status.replicas}')

if [[ -z "$READY" || "$READY" != "$DESIRED" ]]; then
  echo "Deployment is not fully ready: ready=${READY:-0}, desired=${DESIRED:-0}" >&2
  exit 1
fi

echo "Deployment verification passed."
