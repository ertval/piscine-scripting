#!/usr/bin/env bash

set -euo pipefail

if [ -z "${X:-}" ] || [ -z "${Y:-}" ]; then
  echo "false" >&2
  exit 1
fi

if [ "$X" -gt "$Y" ]; then
  echo "true"
else
  echo "false"
fi
