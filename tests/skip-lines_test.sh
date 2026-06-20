#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT="$ROOT_DIR/skip-lines.sh"

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

echo "--- Test 2: skips even lines (only odd lines remain) ---"
total=$(bash "$SCRIPT" 2>/dev/null | wc -l)
full=$(ls -l | wc -l)
expected=$(( (full + 1) / 2 ))
assert_eq "odd line count matches" "$expected" "$total"

echo "--- Test 3: first output line matches ls -l line 1 ---"
first_out=$(bash "$SCRIPT" 2>/dev/null | sed -n '1p')
first_in=$(ls -l | sed -n '1p')
assert_eq "first line matches" "$first_in" "$first_out"

echo ""
echo "=== Results ==="
echo "Passed: $pass"
echo "Failed: $fail"

if [[ $fail -gt 0 ]]; then
	exit 1
fi
exit 0
