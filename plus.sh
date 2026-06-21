#!/usr/bin/env bash

set -euo pipefail

expr "$1" + "$2" || true
