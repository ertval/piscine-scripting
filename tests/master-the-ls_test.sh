#!/usr/bin/env bash

set -e

TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

cd "$TEST_DIR"

run_script() {
    bash "$OLDPWD/master-the-ls.sh"
}

echo "=== Running master-the-ls.sh Tests ==="

# Test 1: Basic listing with directories
mkdir -p dir1 dir2
touch file1.txt file2.txt

OUTPUT=$(run_script)
if echo "$OUTPUT" | grep -q "dir1/" && echo "$OUTPUT" | grep -q "dir2/"; then
    echo "✓ Test 1 Passed: Directories end with /"
else
    echo "✗ Test 1 Failed: Directories missing /"
    echo "Got: $OUTPUT"
    exit 1
fi

# Test 2: Hidden files excluded
touch .hidden_file
mkdir .hidden_dir

OUTPUT=$(run_script)
if echo "$OUTPUT" | grep -q "\.hidden"; then
    echo "✗ Test 2 Failed: Hidden files included"
    echo "Got: $OUTPUT"
    exit 1
else
    echo "✓ Test 2 Passed: Hidden files excluded"
fi

# Test 3: Comma separation
OUTPUT=$(run_script)
if echo "$OUTPUT" | grep -q ","; then
    echo "✓ Test 3 Passed: Comma separation present"
else
    echo "✗ Test 3 Failed: No commas found"
    echo "Got: $OUTPUT"
    exit 1
fi

# Test 4: No trailing comma
OUTPUT=$(run_script)
if [[ "$OUTPUT" == *, ]]; then
    echo "✗ Test 4 Failed: Trailing comma found"
    echo "Got: $OUTPUT"
    exit 1
else
    echo "✓ Test 4 Passed: No trailing comma"
fi

# Test 5: Access time order (create files with different access times)
rm -f * dir* 2>/dev/null || true
touch old_file.txt
sleep 1.1
touch new_file.txt

OUTPUT=$(run_script)
OLD_POS=$(echo "$OUTPUT" | tr ',' '\n' | grep -n "old_file.txt" | cut -d: -f1)
NEW_POS=$(echo "$OUTPUT" | tr ',' '\n' | grep -n "new_file.txt" | cut -d: -f1)

if [ "$NEW_POS" -lt "$OLD_POS" ]; then
    echo "✓ Test 5 Passed: Access time order correct (newer first)"
else
    echo "✗ Test 5 Failed: Wrong order"
    echo "Got: $OUTPUT"
    exit 1
fi

echo "==============================================="
echo "All tests passed successfully!"
