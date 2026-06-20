#!/usr/bin/env bash

set -euo pipefail

# Create a temporary directory for testing
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Running right.sh Tests ==="

# ----------------------------------------------------
# Test 1: Basic filtering - exclude .txt files
# ----------------------------------------------------
echo "Test 1: Basic .txt exclusion"
cd "$TEST_DIR"

touch sample1.txt sample2 sample3.txt sample4

bash "$SCRIPT_DIR/right.sh"

if [ ! -f filtered_files.txt ]; then
    echo "✗ Test 1 Failed: filtered_files.txt not created"
    exit 1
fi

# Sort both expected and actual for comparison
sort filtered_files.txt > filtered_sorted.txt
printf "%s\n" "sample2" "sample4" | sort > expected_sorted.txt

if diff expected_sorted.txt filtered_sorted.txt > /dev/null; then
    echo "✓ Test 1 Passed: Non-.txt files correctly listed"
else
    echo "✗ Test 1 Failed: Expected sample2, sample4 but got:"
    cat filtered_files.txt
    exit 1
fi

# Clean up for next test
rm -rf "$TEST_DIR"/*
cd "$TEST_DIR"

# ----------------------------------------------------
# Test 2: No .txt files present
# ----------------------------------------------------
echo "Test 2: No .txt files in directory"
touch fileA fileB fileC

bash "$SCRIPT_DIR/right.sh"

if [ ! -f filtered_files.txt ]; then
    echo "✗ Test 2 Failed: filtered_files.txt not created"
    exit 1
fi

sort filtered_files.txt > filtered_sorted.txt
printf "%s\n" "fileA" "fileB" "fileC" | sort > expected_sorted.txt

if diff expected_sorted.txt filtered_sorted.txt > /dev/null; then
    echo "✓ Test 2 Passed: All non-.txt files listed"
else
    echo "✗ Test 2 Failed: Expected fileA, fileB, fileC but got:"
    cat filtered_files.txt
    exit 1
fi

# Clean up for next test
rm -rf "$TEST_DIR"/*
cd "$TEST_DIR"

# ----------------------------------------------------
# Test 3: Only .txt files present (empty output)
# ----------------------------------------------------
echo "Test 3: Only .txt files in directory"
touch a.txt b.txt c.txt

bash "$SCRIPT_DIR/right.sh"

if [ -s filtered_files.txt ]; then
    echo "✗ Test 3 Failed: Expected empty filtered_files.txt but got output"
    cat filtered_files.txt
    exit 1
fi

echo "✓ Test 3 Passed: Empty output for only .txt files"

echo "==============================================="
echo "All tests passed successfully!"
