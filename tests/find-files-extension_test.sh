#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT="$ROOT_DIR/find-files-extension.sh"

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

mkdir -p "$TEST_DIR/folder1" "$TEST_DIR/folder2" "$TEST_DIR/folder3/sub-folder4"

# .txt files
touch "$TEST_DIR/folder1/wei.txt"
touch "$TEST_DIR/folder1/ek.txt"
touch "$TEST_DIR/folder2/qwep.txt"
touch "$TEST_DIR/folder2/pq1.txt"
touch "$TEST_DIR/folder2/zzzz.txt"
touch "$TEST_DIR/folder3/ziko.txt"

# Non-.txt files (should be ignored)
touch "$TEST_DIR/folder1/sdn"
touch "$TEST_DIR/folder1/fqo.sh"
touch "$TEST_DIR/folder1/wqk.pdf"
touch "$TEST_DIR/folder2/zqa"
touch "$TEST_DIR/folder2/kwq"
touch "$TEST_DIR/folder2/mzn.01"
touch "$TEST_DIR/folder3/asd.bash"
touch "$TEST_DIR/folder3/ahmed,pdf"
touch "$TEST_DIR/folder3/sub-folder4/abc"
touch "$TEST_DIR/folder3/sub-folder4/x2q"

echo "--- Test 1: exit code 0 ---"
(cd "$TEST_DIR" && bash "$SCRIPT" > /dev/null 2>&1)
assert_eq "exit code is 0" "0" "$?"

echo "--- Test 2: finds only .txt files, strips path and .txt extension ---"
output=$(cd "$TEST_DIR" && bash "$SCRIPT" 2>&1 | grep -v '^$' | sort)
expected=$(printf 'ek\npq1\nqwep\nwei\nziko\nzzzz\n')
assert_eq "all filenames without extension" "$expected" "$output"

echo "--- Test 3: no false positives (non-.txt files excluded) ---"
line_count=$(cd "$TEST_DIR" && bash "$SCRIPT" 2>&1 | grep -c . || true)
assert_eq "exactly 6 txt files found" "6" "$line_count"

echo "--- Test 4: trailing blank line present ---"
last_char=$(cd "$TEST_DIR" && bash "$SCRIPT" 2>&1 | tail -c 1 | xxd -p | tr -d ' ')
assert_eq "last char is newline (0a)" "0a" "$last_char"

echo ""
echo "=== Results ==="
echo "Passed: $pass"
echo "Failed: $fail"

if [[ $fail -gt 0 ]]; then
	exit 1
fi
exit 0
