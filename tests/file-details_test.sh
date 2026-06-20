#!/usr/bin/env bash

set -e

SCRIPT_PATH="/home/ertval/code/zone-modules/piscine-scripting/file-details.sh"

TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

cd "$TEST_DIR"

# Setup hard-perm/ structure
mkdir -p hard-perm/0 hard-perm/3 hard-perm/A
touch hard-perm/{1,2,4,5,6,7,8,9}

# Set permissions: dirs
chmod 401 hard-perm/0 hard-perm/A
chmod 777 hard-perm/3

# Set permissions: files
chmod 402 hard-perm/1 hard-perm/9
chmod 604 hard-perm/2 hard-perm/8
chmod 510 hard-perm/4 hard-perm/7
chmod 460 hard-perm/5 hard-perm/6

# Run script
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
