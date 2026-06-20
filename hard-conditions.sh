#!/usr/bin/env bash

set -euo pipefail

# Check if file argument is provided
if [ "$#" -ne 1 ]; then
  echo "File is not an executable or does not exist"
  exit 0
fi

FILE="$1"

# Check if file exists, is a regular file, and is executable
if [ -f "$FILE" ] && [ -x "$FILE" ]; then
  echo "File is executable"
else
  echo "File is not an executable or does not exist"
fi
