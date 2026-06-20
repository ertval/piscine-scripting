#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT="$ROOT_DIR/head-and-tail.sh"

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

echo "--- Test 1: exit code 0 ---"
bash "$SCRIPT" > /dev/null 2>&1
assert_eq "exit code is 0" "0" "$?"

echo "--- Test 2: first line starts with expected prefix ---"
bash "$SCRIPT" > /tmp/headtail_test.txt 2>&1
first=$(head -1 /tmp/headtail_test.txt)
assert_eq "first line prefix" "Hello My username is:" "${first:0:21}"

echo "--- Test 3: second line starts with expected prefix ---"
last=$(tail -2 /tmp/headtail_test.txt | head -1)
assert_eq "last line prefix" "so my passwd is:" "${last:0:16}"

echo "--- Test 4: third line (via cat -e) is present ---"
line_count=$(cat -e /tmp/headtail_test.txt | wc -l | tr -d ' ')
assert_eq "3 lines with cat -e" "3" "$line_count"

rm -f /tmp/headtail_test.txt

echo ""
echo "=== Results ==="
echo "Passed: $pass"
echo "Failed: $fail"

if [[ $fail -gt 0 ]]; then
	exit 1
fi
exit 0
