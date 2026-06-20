#!/usr/bin/env bash

set -euo pipefail

# List all files in current directory, exclude .txt extensions, save to filtered_files.txt
ls | grep -v '\.txt$' > filtered_files.txt || true
