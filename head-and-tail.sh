#!/usr/bin/env bash

set -euo pipefail

URL="https://assets.01-edu.org/devops-branch/HeadTail.txt"

content=$(curl -s "$URL")

first=$(sed -n '1p' <<< "$content")
last=$(sed -n '$p' <<< "$content")

printf '%s\n%s\n\n' "$first" "$last"
