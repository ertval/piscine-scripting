#!/usr/bin/env bash

set -eu

URL="https://assets.01-edu.org/devops-branch/HeadTail.txt"

curl -s "$URL" | head -1
curl -s "$URL" | tail -1
