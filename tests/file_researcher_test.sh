#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== file-researcher.sh Tests ==="

# Test 1: Script exists and is executable
if [ -x "$SCRIPT_DIR/file-researcher.sh" ]; then
    echo "✓ Test 1: Script exists and is executable"
else
    echo "✗ Test 1: Script missing or not executable"
    exit 1
fi

# Test 2: Output contains the "It takes 12 honey" line
OUTPUT=$(bash "$SCRIPT_DIR/file-researcher.sh")
if echo "$OUTPUT" | grep -q "It takes 12 honeybees"; then
    echo "✓ Test 2: Found 'It takes 12 honeybees' line"
else
    echo "✗ Test 2: Missing 'It takes 12 honeybees' line"
    exit 1
fi

# Test 3: No "echo" in script
if grep -q "echo" "$SCRIPT_DIR/file-researcher.sh"; then
    echo "✗ Test 3: Script contains 'echo' command"
    exit 1
else
    echo "✓ Test 3: No echo command in script"
fi

# Test 4: Facts file exists
if [ -f "$SCRIPT_DIR/file-researcher/facts.txt" ]; then
    echo "✓ Test 4: facts.txt exists"
else
    echo "✗ Test 4: facts.txt missing"
    exit 1
fi

# Test 5: Output has correct number of "year" lines (12)
YEAR_COUNT=$(echo "$OUTPUT" | grep -c "year")
if [ "$YEAR_COUNT" -eq 12 ]; then
    echo "✓ Test 5: Found exactly 12 lines containing 'year'"
else
    echo "✗ Test 5: Expected 12 'year' lines, got $YEAR_COUNT"
    exit 1
fi

# Test 6: Output matches expected line-by-line
EXPECTED_LINES=(
    "It takes 12 honeybees to make one teaspoon of honey"
    "6:898 tornadoes were recorded to have occurred in the United States in the year 2000."
    "12:The only two days of the year in which there are no professional sports games (MLB, NBA, NHL, or NFL) are the day before and the day after the Major League All-Star Game."
    "15:All dogs are the descendant of the wolf. These wolves lived in eastern Asia about 15,000 years ago"
    "32:Most fleas do not live past a year old"
    "39:Every 238 years, the orbits of Neptune and Pluto change making Neptune at times the farthest planet from the sun"
    "60:A maple tree is usually tapped when the tree is at least 45 years old and has a diameter of 12 inches"
    "63:An acre of trees can remove about 13 tons of dust and gases every year from the surrounding environment"
    "67:Every year, 100 million sharks are killed by people"
    "70:One female mouse can produce up to 100 babies a year"
    "95:In Johannesburg, the average car will be involved in an accident once every four years."
    "96:The youngest actress to be nominated as best actress is Keisha Castle-Hughes who was nominated at just 13 years old"
    "121:In an average lifetime, a person will spend 4 years traveling in an automobile and six months waiting at a red light."
)

mapfile -t OUTPUT_LINES <<< "$OUTPUT"

for i in "${!EXPECTED_LINES[@]}"; do
    if [ "${OUTPUT_LINES[$i]}" = "${EXPECTED_LINES[$i]}" ]; then
        echo "✓ Test 6.$((i+1)): Line $((i+1)) matches expected"
    else
        echo "✗ Test 6.$((i+1)): Line $((i+1)) mismatch"
        echo "  Expected: ${EXPECTED_LINES[$i]}"
        echo "  Got:      ${OUTPUT_LINES[$i]}"
        exit 1
    fi
done

echo "==============================================="
echo "All tests passed successfully!"
