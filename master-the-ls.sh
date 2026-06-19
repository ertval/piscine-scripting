#!/usr/bin/env bash
set -euo pipefail

# List files/dirs, exclude hidden (and . and ..), sort by access time (newest first),
# append / to directories, separate with commas.

ls -1uF | grep -v '^\.' | tr '\n' ',' | sed 's/,$//'
