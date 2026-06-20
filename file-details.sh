#!/usr/bin/env bash

set -euo pipefail

if [ -n "${1:-}" ]; then
    HARD_PERM_DIR="$1"
elif [ "$(basename "$PWD")" = "hard-perm" ]; then
    HARD_PERM_DIR="."
elif [ -d "hard-perm" ]; then
    HARD_PERM_DIR="hard-perm"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    HARD_PERM_DIR="$SCRIPT_DIR/hard-perm"
fi

ls -l --time-style='+%F %R' "$HARD_PERM_DIR" | sed '1d' | awk '{print $1, $6, $7, $8}'
