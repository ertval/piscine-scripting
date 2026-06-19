#!/usr/bin/env bash

set -euo pipefail

URL="https://assets.01-edu.org/devops-branch/HeadTail.txt"

curl -s "$URL" > /tmp/HeadTail.txt
head -1 /tmp/HeadTail.txt
tail -1 /tmp/HeadTail.txt
printf '\n'
rm -f /tmp/HeadTail.txt
