#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="platform-dev"

sudo -E talosctl cluster create docker \
  --name "${CLUSTER_NAME}" \
  --workers 2 \
  --config-patch @infra/talos/patches/disable-default-cni.yaml \
  --wait-timeout 3m || true

echo "Fetching kubeconfig (cluster may show not-Ready until CNI is installed)..."
sudo -E talosctl kubeconfig --force ~/.kube/config --merge=false --talosconfig ~/.talos/config
sudo chown "$(id -u):$(id -g)" ~/.kube/config

echo "Done. Run: kubectl get nodes"
