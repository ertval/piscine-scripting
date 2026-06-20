#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(cd "$(dirname "$0")/.." && pwd)/file-details.sh"

# Change to a temp dir WITHOUT hard-perm/ to verify script finds it via SCRIPT_DIR
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

cd "$TEST_DIR"

# Run script from a directory that has no hard-perm/ subfolder
OUTPUT=$(bash "$SCRIPT_PATH")

# Test: output not empty
if [ -z "$OUTPUT" ]; then
    echo "FAIL: empty output"
    exit 1
fi

# Test: each line has 4 fields
LINE_NUM=0
while IFS= read -r line; do
    LINE_NUM=$((LINE_NUM + 1))
    FIELDS=$(echo "$line" | awk '{print NF}')
    if [ "$FIELDS" -ne 4 ]; then
        echo "FAIL: line $LINE_NUM has $FIELDS fields, expected 4: $line"
        exit 1
    fi
done <<< "$OUTPUT"

# Test: filenames 0-9 and A all present
for name in 0 1 2 3 4 5 6 7 8 9 A; do
    if ! echo "$OUTPUT" | grep -q "$name$"; then
        echo "FAIL: filename $name not found in output"
        exit 1
    fi
done

echo "PASS: file-details_test — $LINE_NUM lines, all 4 fields, all filenames present"
