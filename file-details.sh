#!/usr/bin/env bash

set -euo pipefail

HARD_PERM_DIR="${1:-hard-perm}"

if [ $# -eq 0 ] && [ ! -d "$HARD_PERM_DIR" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    HARD_PERM_DIR="$SCRIPT_DIR/hard-perm"
fi

ls -l --time-style='+%F %R' "$HARD_PERM_DIR" | sed '1d' | awk '{print $1, $6, $7, $8}'
