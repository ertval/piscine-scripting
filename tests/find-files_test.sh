#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT="$ROOT_DIR/find-files.sh"

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

touch "$TEST_DIR/folder1/aolder_lol"
touch "$TEST_DIR/folder1/ek" "$TEST_DIR/folder1/fqo" "$TEST_DIR/folder1/sdn"
touch "$TEST_DIR/folder2/zzzz" "$TEST_DIR/folder2/zqa"
mkdir -p "$TEST_DIR/folder2/zzzzz"
touch "$TEST_DIR/folder3/asd" "$TEST_DIR/folder3/ahmed"
touch "$TEST_DIR/folder3/sub-folder4/abc" "$TEST_DIR/folder3/sub-folder4/a_correct" "$TEST_DIR/folder3/sub-folder4/aefg"
# File with space in name
touch "$TEST_DIR/folder3/asd 2"

echo "--- Test 1: exit code 0 ---"
(cd "$TEST_DIR" && bash "$SCRIPT" > /dev/null 2>&1)
assert_eq "exit code is 0" "0" "$?"

echo "--- Test 2: finds entries starting with 'a' (files and dirs) ---"
output=$(cd "$TEST_DIR" && bash "$SCRIPT" 2>&1 | sort)
# Expected: all files/dirs starting with 'a' plus regular files ending with 'z'
expected=$(cat <<'EOF'
./folder1/aolder_lol
./folder2/zzzz
./folder3/ahmed
./folder3/asd
./folder3/asd 2
./folder3/sub-folder4/a_correct
./folder3/sub-folder4/abc
./folder3/sub-folder4/aefg
EOF
)
assert_eq "all expected entries found" "$expected" "$output"

echo "--- Test 3: no false positives ---"
# Count should be exactly 8
line_count=$(cd "$TEST_DIR" && bash "$SCRIPT" 2>&1 | wc -l | tr -d ' ')
assert_eq "exactly 8 lines" "8" "$line_count"

echo ""
echo "=== Results ==="
echo "Passed: $pass"
echo "Failed: $fail"

if [[ $fail -gt 0 ]]; then
	exit 1
fi
exit 0
