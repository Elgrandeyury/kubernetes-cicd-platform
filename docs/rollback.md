# Rollback Runbook

## Kubernetes Deployment rollback

Inspect rollout history:

```bash
kubectl -n platform-app rollout history deployment/platform-app
```

Rollback one revision:

```bash
kubectl -n platform-app rollout undo deployment/platform-app
kubectl -n platform-app rollout status deployment/platform-app
```

Rollback to a specific revision:

```bash
kubectl -n platform-app rollout undo deployment/platform-app --to-revision=<revision>
```

## Helm rollback

Inspect release history:

```bash
helm history platform-app -n platform-app
```

Rollback:

```bash
helm rollback platform-app <revision> -n platform-app --wait
```

## Verification after rollback

```bash
kubectl -n platform-app get pods
kubectl -n platform-app rollout status deployment/platform-app
kubectl -n platform-app get events --sort-by=.lastTimestamp
```

Confirm the health endpoints and application behavior before declaring recovery complete.
