#!/usr/bin/env bash

set -e

TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

cd "$TEST_DIR"

run_script() {
    bash "$OLDPWD/hard-perm.sh"
}

echo "=== Running hard-perm.sh Tests ==="

# Setup: create hard-perm/ structure
mkdir -p hard-perm/0 hard-perm/3 hard-perm/A
touch hard-perm/1 hard-perm/2 hard-perm/4 hard-perm/5
touch hard-perm/6 hard-perm/7 hard-perm/8 hard-perm/9

# Initial permissions: 775 for dirs, 664 for files
chmod 775 hard-perm/0 hard-perm/3 hard-perm/A
chmod 664 hard-perm/1 hard-perm/2 hard-perm/4 hard-perm/5
chmod 664 hard-perm/6 hard-perm/7 hard-perm/8 hard-perm/9

run_script

# Test each entry's permissions
# 0 (dir) → 401
PERM=$(stat -c "%a" hard-perm/0)
TYPE=$(stat -c "%F" hard-perm/0)
if [ "$PERM" = "401" ] && [ "$TYPE" = "directory" ]; then
    echo "✓ Test 0 Passed: hard-perm/0 is dr-------x (401)"
else
    echo "✗ Test 0 Failed: Expected 401 directory, got $PERM $TYPE"
    exit 1
fi

# 1 (file) → 402
PERM=$(stat -c "%a" hard-perm/1)
TYPE=$(stat -c "%F" hard-perm/1)
if [ "$PERM" = "402" ] && [[ "$TYPE" == "regular"* ]]; then
    echo "✓ Test 1 Passed: hard-perm/1 is -r------w- (402)"
else
    echo "✗ Test 1 Failed: Expected 402 regular file, got $PERM $TYPE"
    exit 1
fi

# 2 (file) → 604
PERM=$(stat -c "%a" hard-perm/2)
if [ "$PERM" = "604" ]; then
    echo "✓ Test 2 Passed: hard-perm/2 is -rw----r-- (604)"
else
    echo "✗ Test 2 Failed: Expected 604, got $PERM"
    exit 1
fi

# 3 (dir) → 777
PERM=$(stat -c "%a" hard-perm/3)
TYPE=$(stat -c "%F" hard-perm/3)
if [ "$PERM" = "777" ] && [ "$TYPE" = "directory" ]; then
    echo "✓ Test 3 Passed: hard-perm/3 is drwxrwxrwx (777)"
else
    echo "✗ Test 3 Failed: Expected 777 directory, got $PERM $TYPE"
    exit 1
fi

# 4 (file) → 510
PERM=$(stat -c "%a" hard-perm/4)
if [ "$PERM" = "510" ]; then
    echo "✓ Test 4 Passed: hard-perm/4 is -r-x--x--- (510)"
else
    echo "✗ Test 4 Failed: Expected 510, got $PERM"
    exit 1
fi

# 5 (file) → 460
PERM=$(stat -c "%a" hard-perm/5)
if [ "$PERM" = "460" ]; then
    echo "✓ Test 5 Passed: hard-perm/5 is -r--rw---- (460)"
else
    echo "✗ Test 5 Failed: Expected 460, got $PERM"
    exit 1
fi

# 6 (file) → 460
PERM=$(stat -c "%a" hard-perm/6)
if [ "$PERM" = "460" ]; then
    echo "✓ Test 6 Passed: hard-perm/6 is -r--rw---- (460)"
else
    echo "✗ Test 6 Failed: Expected 460, got $PERM"
    exit 1
fi

# 7 (file) → 510
PERM=$(stat -c "%a" hard-perm/7)
if [ "$PERM" = "510" ]; then
    echo "✓ Test 7 Passed: hard-perm/7 is -r-x--x--- (510)"
else
    echo "✗ Test 7 Failed: Expected 510, got $PERM"
    exit 1
fi

# 8 (file) → 604
PERM=$(stat -c "%a" hard-perm/8)
if [ "$PERM" = "604" ]; then
    echo "✓ Test 8 Passed: hard-perm/8 is -rw----r-- (604)"
else
    echo "✗ Test 8 Failed: Expected 604, got $PERM"
    exit 1
fi

# 9 (file) → 402
PERM=$(stat -c "%a" hard-perm/9)
if [ "$PERM" = "402" ]; then
    echo "✓ Test 9 Passed: hard-perm/9 is -r------w- (402)"
else
    echo "✗ Test 9 Failed: Expected 402, got $PERM"
    exit 1
fi

# A (dir) → 401
PERM=$(stat -c "%a" hard-perm/A)
TYPE=$(stat -c "%F" hard-perm/A)
if [ "$PERM" = "401" ] && [ "$TYPE" = "directory" ]; then
    echo "✓ Test A Passed: hard-perm/A is dr-------x (401)"
else
    echo "✗ Test A Failed: Expected 401 directory, got $PERM $TYPE"
    exit 1
fi

echo "==============================================="
echo "All tests passed successfully!"
