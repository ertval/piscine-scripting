#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="$(cd "$(dirname "$0")/.." && pwd)/details.sh"

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

# Test 1: custom path
touch "$TEMP_DIR/myfile.txt"
bash "$SCRIPT_PATH" "$TEMP_DIR/myfile.txt"
size=$(stat -c %s "$TEMP_DIR/myfile.txt")
[ "$size" -eq 1000 ] || { echo "FAIL [custom path]: size=$size"; exit 1; }
[ "$(stat -c %a "$TEMP_DIR/myfile.txt")" = "600" ] || { echo "FAIL [custom path]: perms=$(stat -c %a "$TEMP_DIR/myfile.txt")"; exit 1; }
[[ "$(stat -c %y "$TEMP_DIR/myfile.txt")" == 2022-01-01* ]] || { echo "FAIL [custom path]: modify time"; exit 1; }
[[ "$(stat -c %x "$TEMP_DIR/myfile.txt")" == 2022-01-01* ]] || { echo "FAIL [custom path]: access time"; exit 1; }
echo "PASS [custom path]"

# Test 2: defaults to file1.txt in CWD
cd "$TEMP_DIR"
touch file1.txt
bash "$SCRIPT_PATH"
size=$(stat -c %s "file1.txt")
[ "$size" -eq 1000 ] || { echo "FAIL [default file1.txt]: size=$size"; exit 1; }
[ "$(stat -c %a "file1.txt")" = "600" ] || { echo "FAIL [default file1.txt]: perms"; exit 1; }
[[ "$(stat -c %y "file1.txt")" == 2022-01-01* ]] || { echo "FAIL [default file1.txt]: modify time"; exit 1; }
[[ "$(stat -c %x "file1.txt")" == 2022-01-01* ]] || { echo "FAIL [default file1.txt]: access time"; exit 1; }
echo "PASS [default file1.txt]"

echo "=== ALL TESTS PASSED ==="
