# Deployment Guide

This repository supports two deployment paths: Kustomize overlays and the Helm chart. Deployment is only considered verified after a real Kubernetes cluster has accepted the resources and the application has passed rollout and health checks.

## Kustomize

Render first:

```bash
kubectl kustomize k8s/overlays/dev
kubectl kustomize k8s/overlays/prod
```

Deploy an environment:

```bash
kubectl apply -k k8s/overlays/dev
# or
kubectl apply -k k8s/overlays/prod
```

Verify:

```bash
kubectl -n platform-app get deploy,pods,svc,ingress,hpa,pdb
kubectl -n platform-app rollout status deployment/platform-app
```

## Helm

Validate locally before installation:

```bash
helm lint helm/platform-app
helm template platform-app helm/platform-app
```

Install or upgrade:

```bash
helm upgrade --install platform-app helm/platform-app \
  --namespace platform-app \
  --create-namespace \
  --set image.tag=<immutable-image-tag>
```

Do not use mutable `latest` tags for a real production deployment. Prefer a commit SHA or release version.

## Deployment evidence

For portfolio verification, capture sanitized proof of:

- successful rollout status
- running pods and replica count
- ingress/service endpoint
- HPA configuration
- application health endpoint
- CI/CD run that built and scanned the image
