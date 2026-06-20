#!/usr/bin/env bash
set -euo pipefail

echo "=== Running Escape Characters Validation Tests ==="

check_file() {
    local filepath="$1"
    local desc="$2"
    
    if [ ! -f "$filepath" ]; then
        echo "✗ Test Failed: $desc does not exist"
        exit 1
    fi
    
    # Check exact size (should be 19 bytes)
    local size
    size=$(wc -c < "$filepath" | tr -d ' ')
    if [ "$size" -ne 19 ]; then
        echo "✗ Test Failed: $desc size is $size bytes, expected 19 bytes (no newlines allowed)"
        exit 1
    fi
    
    # Check content
    local content
    content=$(cat "$filepath")
    if [ "$content" != "Random text inside!" ]; then
        echo "✗ Test Failed: $desc content is incorrect: '$content'"
        exit 1
    fi
    
    echo "✓ Test Passed: $desc check (size $size bytes, correct content)"
}

check_file "firstFile" "firstFile"
check_file '"medium_File!"' '"medium_File!"'
check_file '"\?$*'\''Hard_file'\''*$?\"' '"\?$*'\''Hard_file'\''*$?\"'

echo "==============================================="
echo "All tests passed successfully!"
