#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT="$ROOT_DIR/left.sh"

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

# Create a temporary directory for testing
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

echo "--- Test 1: Count 5 lines ---"
# Create a facts file with 5 lines in the temp dir
cat <<'EOF' > "$TEST_DIR/facts"
line 1
line 2
line 3
line 4
line 5
EOF

# Run left.sh inside the directory with the facts file
cd "$TEST_DIR"
output=$(bash "$SCRIPT")
assert_eq "line count is 5" "5" "$output"

echo "--- Test 2: Count 0 lines ---"
# Create an empty facts file
printf "" > "$TEST_DIR/facts"
output=$(bash "$SCRIPT")
assert_eq "line count is 0" "0" "$output"

echo ""
echo "=== Results ==="
echo "Passed: $pass"
echo "Failed: $fail"

if [[ $fail -gt 0 ]]; then
	exit 1
fi
exit 0
