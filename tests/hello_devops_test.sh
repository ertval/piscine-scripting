#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Create a temporary directory for our mock commands
MOCK_DIR=$(mktemp -d)
trap 'rm -rf "$MOCK_DIR"' EXIT

# Helper function to execute hello-devops.sh with mocked PATH
run_script() {
    PATH="$MOCK_DIR:$PATH" bash hello-devops.sh
}

echo "=== Running hello-devops.sh Correctness Tests ==="

# ----------------------------------------------------
# Test 1: gh CLI works and returns username
# ----------------------------------------------------
echo '#!/bin/bash
if [[ "$*" == *"api user"* ]]; then
    echo "gh_mock_user"
else
    exit 1
fi' > "$MOCK_DIR/gh"
chmod +x "$MOCK_DIR/gh"

echo '#!/bin/bash
exit 1' > "$MOCK_DIR/git"
chmod +x "$MOCK_DIR/git"

OUTPUT=$(run_script)
if [ "$OUTPUT" = "Hello gh_mock_user!" ]; then
    echo "✓ Test 1 Passed: gh CLI username resolved."
else
    echo "✗ Test 1 Failed: Expected 'Hello gh_mock_user!', got '$OUTPUT'"
    exit 1
fi

# ----------------------------------------------------
# Test 2: gh CLI fails, Git remote origin URL parsed
# ----------------------------------------------------
echo '#!/bin/bash
exit 1' > "$MOCK_DIR/gh"
chmod +x "$MOCK_DIR/gh"

echo '#!/bin/bash
echo "https://platform.zone01.gr/git/git_mock_user/piscine-scripting.git"' > "$MOCK_DIR/git"
chmod +x "$MOCK_DIR/git"

OUTPUT=$(run_script)
if [ "$OUTPUT" = "Hello git_mock_user!" ]; then
    echo "✓ Test 2 Passed: Git remote parsed correctly."
else
    echo "✗ Test 2 Failed: Expected 'Hello git_mock_user!', got '$OUTPUT'"
    exit 1
fi

# ----------------------------------------------------
# Test 3: Both fail, defaults to ekaramet
# ----------------------------------------------------
echo '#!/bin/bash
exit 1' > "$MOCK_DIR/gh"
chmod +x "$MOCK_DIR/gh"

echo '#!/bin/bash
exit 1' > "$MOCK_DIR/git"
chmod +x "$MOCK_DIR/git"

OUTPUT=$(run_script)
if [ "$OUTPUT" = "Hello ekaramet!" ]; then
    echo "✓ Test 3 Passed: Default fallback resolved correctly."
else
    echo "✗ Test 3 Failed: Expected 'Hello ekaramet!', got '$OUTPUT'"
    exit 1
fi

echo "==============================================="
echo "All tests passed successfully!"
