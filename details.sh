#!/usr/bin/env bash

set -euo pipefail

FILE="${1:-file1.txt}"

truncate -s 1000 "$FILE"
chmod 600 "$FILE"
touch -d "2022-01-01" "$FILE"
