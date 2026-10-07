# Security Design

The project applies defense-in-depth controls at the container, Kubernetes workload, network, and delivery-pipeline layers.

## Container

- non-root runtime user
- read-only root filesystem
- no privilege escalation
- all Linux capabilities dropped
- small dependency footprint
- image vulnerability scanning in CI

## Kubernetes workload

- `runAsNonRoot`
- RuntimeDefault seccomp profile
- resource requests and limits
- startup, readiness, and liveness probes
- PodDisruptionBudget
- rolling updates with zero planned unavailability
- NetworkPolicy in the base manifests

## Configuration and secrets

Non-sensitive configuration belongs in ConfigMaps or Helm values. Real secrets must not be committed to Git. In a real platform, use a Kubernetes Secret populated through a secure external secret-management workflow such as a cloud secrets manager or an external-secrets controller.

## CI/CD

CI renders Kustomize overlays, validates Helm templates, builds the container image, and scans both the image and Kubernetes configuration. The deployment workflow uses GitHub Container Registry and expects cluster credentials to be supplied through GitHub Actions secrets rather than committed files.

## Remaining runtime controls

Runtime proof should include RBAC review, namespace-level admission policy where available, ingress TLS, registry/image provenance, and cluster audit/monitoring. These are environment-dependent and are not claimed as deployed by this repository alone.
