#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT="$ROOT_DIR/set-internal-vars.sh"

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

echo "--- Test 2: stdout matches expected ---"
output=$(bash "$SCRIPT")
expected=$(cat <<'EOF'
Hello World
100
3.142
one, two, three, four, five
EOF
)
assert_eq "output matches exactly" "$expected" "$output"

echo ""
echo "=== Results ==="
echo "Passed: $pass"
echo "Failed: $fail"

if [[ $fail -gt 0 ]]; then
	exit 1
fi
exit 0
