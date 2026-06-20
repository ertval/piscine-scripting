#!/usr/bin/env bash

set -euo pipefail

# Verify X and Y environment variables are set
if [ -z "${X:-}" ] || [ -z "${Y:-}" ]; then
  echo "Error: X and Y must be set" >&2
  exit 1
fi

if [ "$X" -gt "$Y" ]; then
  echo "true"
else
  echo "false"
fi
