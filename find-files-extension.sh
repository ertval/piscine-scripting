#!/usr/bin/env bash

set -euo pipefail

find . -iregex '.*\.\(txt\)' -printf '%f\n' | sed 's/\.txt$//' | sort
echo
