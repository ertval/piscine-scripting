#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== json-researcher.sh Tests ==="

# Test 1: Script exists and is executable
if [ -x "$SCRIPT_DIR/json-researcher.sh" ]; then
	echo "✓ Test 1: Script exists and is executable"
else
	echo "✗ Test 1: Script missing or not executable"
	exit 1
fi

# Test 2: Output contains the correct name and power for id 1
OUTPUT=$(bash "$SCRIPT_DIR/json-researcher.sh")
if echo "$OUTPUT" | grep -q '"name": "A-Bomb"'; then
	echo "✓ Test 2: Found expected name 'A-Bomb'"
else
	echo "✗ Test 2: Missing expected name"
	echo "  Got: $OUTPUT"
	exit 1
fi

if echo "$OUTPUT" | grep -q '"power": 24'; then
	echo "✓ Test 3: Found expected power 24"
else
	echo "✗ Test 3: Missing expected power"
	echo "  Got: $OUTPUT"
	exit 1
fi

# Test 4: Output has exactly 2 non-empty lines
LINE_COUNT=$(echo "$OUTPUT" | grep -c . || true)
if [ "$LINE_COUNT" -eq 2 ]; then
	echo "✓ Test 4: Output has exactly 2 lines"
else
	echo "✗ Test 4: Expected 2 lines, got $LINE_COUNT"
	echo "  Got: $OUTPUT"
	exit 1
fi

# Test 5: Output lines end with comma
if echo "$OUTPUT" | grep -q ',$'; then
	echo "✓ Test 5: Lines end with comma"
else
	echo "✗ Test 5: Lines missing trailing comma"
	echo "  Got: $OUTPUT"
	exit 1
fi

echo "==============================================="
echo "All tests passed successfully!"
