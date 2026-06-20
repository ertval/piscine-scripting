#!/usr/bin/env bash

set -e

TEST_DIR=$(mktemp -d)
LS_OUTPUT_FILE=$(mktemp)
trap 'rm -rf "$TEST_DIR"; rm -f "$LS_OUTPUT_FILE"' EXIT

cd "$TEST_DIR"

# bash non-interactive → aliases don't expand by default
shopt -s expand_aliases

# Source the script FIRST so alias exists before any function definition
# (aliases are expanded at parse time, so function bodies reference expanded alias)
source "$OLDPWD/custom-ls.sh"

# Define helper AFTER alias exists — alias expands at function definition time
run_custom_ls() {
    custom-ls > "$LS_OUTPUT_FILE" 2>&1
    cat "$LS_OUTPUT_FILE"
}

echo "=== Running custom-ls.sh Tests ==="

# Test 1: alias resolves to correct command
echo "  Test 1: alias resolution"
ALIAS_OUTPUT=$(alias custom-ls 2>/dev/null || true)
if echo "$ALIAS_OUTPUT" | grep -q "ls -loasS"; then
    echo "✓ Test 1 Passed: alias resolves to 'ls -loasS'"
else
    echo "✗ Test 1 Failed: alias mismatch"
    echo "Got: $ALIAS_OUTPUT"
    exit 1
fi

# Setup: create files of different sizes (including hidden)
# 10-byte file
printf "1234567890" > file_small.txt
# 200-byte file (largest visible)
python3 -c "print('x'*199)" > file_large.txt 2>/dev/null || printf '%0.sx' {1..199} > file_large.txt
# 50-byte hidden file
printf "abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuv" > .hidden_file.txt
# 100-byte hidden file (largest hidden)
python3 -c "print('y'*99)" > .hidden_large.txt 2>/dev/null || printf '%0.sy' {1..99} > .hidden_large.txt
# empty file
touch empty.txt

OUTPUT=$(run_custom_ls)

# Test 2: output contains "total" line
echo "  Test 2: total line"
if echo "$OUTPUT" | grep -q "^total "; then
    echo "✓ Test 2 Passed: 'total' line present"
else
    echo "✗ Test 2 Failed: no 'total' line"
    echo "Got: $OUTPUT"
    exit 1
fi

# Test 3: output contains block counts (number before permissions)
echo "  Test 3: block counts"
if echo "$OUTPUT" | grep -E "^[[:space:]]*[0-9]+[[:space:]]+-[-rwx]{9}" | head -1 | grep -qE "^[[:space:]]*[0-9]+"; then
    echo "✓ Test 3 Passed: block counts present"
else
    echo "✗ Test 3 Failed: no block counts found"
    echo "Got: $OUTPUT"
    exit 1
fi

# Test 4: output contains permissions
echo "  Test 4: permissions"
if echo "$OUTPUT" | grep -qE "\-rw\-r\-\-r\-\-"; then
    echo "✓ Test 4 Passed: permissions present"
else
    echo "✗ Test 4 Failed: no permissions found"
    echo "Got: $OUTPUT"
    exit 1
fi

# Test 5: NO group info (ls -o omits group column)
# With -los, fields: blocks perms links owner size month day time name
# Owner (field 4) is followed directly by size (field 5, numeric).
# If group present, field 5 would be a group name (alpha), not numeric.
echo "  Test 5: no group info"
# awk: exit 1 if any non-total line has non-numeric field 5 (indicating a group column)
if echo "$OUTPUT" | grep -v "^total" | grep -v "^$" | awk '$5 !~ /^[0-9]+$/ {exit 1}'; then
    echo "✓ Test 5 Passed: no group column"
else
    echo "✗ Test 5 Failed: group column likely present"
    echo "Got: $OUTPUT"
    exit 1
fi

# Test 6: includes hidden files (starting with .)
echo "  Test 6: hidden files"
if echo "$OUTPUT" | grep -q "\.hidden_file\.txt" && echo "$OUTPUT" | grep -q "\.hidden_large\.txt"; then
    echo "✓ Test 6 Passed: hidden files included"
else
    echo "✗ Test 6 Failed: hidden files missing"
    echo "Got: $OUTPUT"
    exit 1
fi

# Test 7: sorted by size descending (largest first)
echo "  Test 7: size sort descending"
# With -loasS: blocks perms links owner size month day time name → size is field 5
SIZES=$(echo "$OUTPUT" | grep -v "^total" | grep -v "^$" | grep -v " \\.\\.$" | grep -v " \\.$" | awk '{print $5}')
PREV=999999999
FAIL_SORT=0
for S in $SIZES; do
    if [ "$S" -gt "$PREV" ] 2>/dev/null; then
        FAIL_SORT=1
        break
    fi
    PREV=$S
done
if [ "$FAIL_SORT" -eq 0 ]; then
    echo "✓ Test 7 Passed: sorted by size descending"
else
    echo "✗ Test 7 Failed: not sorted by size"
    echo "Got sizes: $SIZES"
    echo ""
    echo "Full output:"
    echo "$OUTPUT"
    exit 1
fi

echo "==============================================="
echo "All tests passed successfully!"
