#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HARD_PERM_DIR="$SCRIPT_DIR/hard-perm"

# Ensure permissions are set (git doesn't preserve mode bits)
(cd "$SCRIPT_DIR" && bash hard-perm.sh)

ls -l --time-style='+%F %R' "$HARD_PERM_DIR" | sed '1d' | awk '{print $1, $6, $7, $8}'
