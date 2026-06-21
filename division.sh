#!/usr/bin/env bash

if [[ $# -lt 2 ]]; then
    echo "Error: two numbers must be provided"
    exit 1
fi

if ! [[ "$1" =~ ^-?[0-9]+$ ]]; then
    echo "Error: both arguments must be integers"
    exit 1
fi

if ! [[ "$2" =~ ^-?[0-9]+$ ]]; then
    echo "Error: both arguments must be integers"
    exit 1
fi

if [[ "$2" -eq 0 ]]; then
    echo "Error: division by zero is not allowed"
    exit 1
fi

# Use bc to handle very large integers
echo "scale=0; $1 / $2" | bc
