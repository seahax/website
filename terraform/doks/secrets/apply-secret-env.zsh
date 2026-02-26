#!/usr/bin/env zsh
set -e

if [[ $# -lt 2 ]]; then
  cat <<EOF
Usage: $0 <namespace> <name> [env-file]

Apply a Kubernetes secret from an env file. If the [env-file] argument is
omitted, then <name> will be used as the env file name. The env file
should have lines in the format KEY=VALUE.

Examples:

  # Use the env filename as the secret name.
  $0 default my-secret.env

  # Use secret name that is different from the env filename.
  $0 default my.env my-secret

EOF
  exit 1
fi

kubectl create secret generic "$2" --namespace="$1" --from-env-file="${3:-$2}" --dry-run=client -o yaml | kubectl apply -f -
