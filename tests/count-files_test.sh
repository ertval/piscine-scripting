#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT="$ROOT_DIR/count-files.sh"

pass=0
fail=0

assert_eq() {
	local desc="$1" expected="$2" actual="$3"
	if [[ "$expected" == "$actual" ]]; then
		echo "PASS: $desc"
		pass=$((pass + 1))
	else
		echo "FAIL: $desc"
		echo "  expected: $expected"
		echo "  actual:   $actual"
		fail=$((fail + 1))
	fi
}

# Create temp dir with test structure
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

# Root dir only (1 dir)
# Create subdirectories
mkdir -p "$TEST_DIR/folder1" "$TEST_DIR/folder2" "$TEST_DIR/folder3/sub-folder4"

# Create regular files
touch "$TEST_DIR/file1.txt"
touch "$TEST_DIR/folder1/a.txt"
touch "$TEST_DIR/folder2/b.txt"
touch "$TEST_DIR/folder3/c.txt"
touch "$TEST_DIR/folder3/sub-folder4/d.txt"

echo "--- Test 1: exit code 0 ---"
(cd "$TEST_DIR" && bash "$SCRIPT" > /dev/null 2>&1)
assert_eq "exit code is 0" "0" "$?"

echo "--- Test 2: outputs exactly one number ---"
output=$(cd "$TEST_DIR" && bash "$SCRIPT" 2>&1)
assert_eq "single numeric output" "1" "$(echo "$output" | wc -l | tr -d ' ')"
assert_eq "output is numeric" "1" "$(echo "$output" | grep -c '^[0-9]\+$' || true)"

echo "--- Test 3: correct count ---"
# Count: 5 files + 5 directories (., folder1, folder2, folder3, sub-folder4) = 10
output=$(cd "$TEST_DIR" && bash "$SCRIPT" 2>&1)
assert_eq "count is 10" "10" "$output"

echo ""
echo "=== Results ==="
echo "Passed: $pass"
echo "Failed: $fail"

if [[ $fail -gt 0 ]]; then
	exit 1
fi
exit 0