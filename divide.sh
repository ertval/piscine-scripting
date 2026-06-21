#!/usr/bin/env bash

set -euo pipefail

# Check argument count
if [[ $# -ne 2 ]]; then
    echo "Error: two numbers must be provided."
    exit 1
fi

# Check if both arguments are integers (allow optional leading minus)
if ! [[ $1 =~ ^-?[0-9]+$ ]] || ! [[ $2 =~ ^-?[0-9]+$ ]]; then
    echo "Error: both arguments must be integers."
    exit 1
fi

# Check for division by zero
if [[ $2 -eq 0 ]]; then
    echo "Error: division by zero is not allowed."
    exit 1
fi

# Perform integer division using bc for arbitrary precision
echo "$1 / $2" | bc