#!/usr/bin/env bash

set -euo pipefail

ls -l --time-style='+%F %R' hard-perm/ | sed '1d' | awk '{print $1, $6, $7, $8}'
