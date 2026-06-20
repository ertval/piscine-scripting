#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(cd "$(dirname "$0")/.." && pwd)/file-details.sh"

run_test() {
    local label="$1" output line_num name

    output=$(bash "$SCRIPT_PATH")

    if [ -z "$output" ]; then
        echo "FAIL [$label]: empty output"
        exit 1
    fi

    line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        fields=$(echo "$line" | awk '{print NF}')
        if [ "$fields" -ne 4 ]; then
            echo "FAIL [$label]: line $line_num has $fields fields, expected 4: $line"
            exit 1
        fi
    done <<< "$output"

    for name in 0 1 2 3 4 5 6 7 8 9 A; do
        if ! echo "$output" | grep -q "$name$"; then
            echo "FAIL [$label]: filename $name not found"
            exit 1
        fi
    done

    echo "PASS [$label]: $line_num lines, 4 fields each, all filenames"
}

# Test 1: CWD has hard-perm/ (grader scenario)
td1=$(mktemp -d)
trap 'rm -rf "$td1"' EXIT
cd "$td1"
mkdir -p hard-perm/0 hard-perm/3 hard-perm/A
touch hard-perm/{1,2,4,5,6,7,8,9}
chmod 401 hard-perm/0 hard-perm/A
chmod 777 hard-perm/3
chmod 402 hard-perm/1 hard-perm/9
chmod 604 hard-perm/2 hard-perm/8
chmod 510 hard-perm/4 hard-perm/7
chmod 460 hard-perm/5 hard-perm/6
run_test "CWD has hard-perm/"

# Test 2: CWD has NO hard-perm/ (fallback to SCRIPT_DIR)
td2=$(mktemp -d)
trap 'rm -rf "$td2"' EXIT
cd "$td2"
run_test "no hard-perm in CWD"

echo "=== ALL TESTS PASSED ==="
