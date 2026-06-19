#!/usr/bin/env bash

set -euo pipefail

files=$(find . -type f | wc -l)
dirs=$(find . -type d | wc -l)

echo $((files + dirs))