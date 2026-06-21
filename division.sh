#!/usr/bin/env bash

# Handle argument count
case $# in
	0|1)
		echo "Error: two numbers must be provided." >&2
		exit 1
		;;
esac

# Validate integers (optional single + or -, followed by digits)
for arg in "$1" "$2"; do
	case $arg in
		*[!0-9+-]* | *[+-]*[+-]* | *[0-9][+-]* | '' | [-+] )
			echo "Error: both arguments must be integers." >&2
			exit 1
			;;
	esac
done

# Check for division by zero (any representation of zero: 0, -0, +0, 00, -00, etc.)
case $2 in
	*[1-9]*)
		;;
	*)
		echo "Error: division by zero is not allowed." >&2
		exit 1
		;;
esac

# Perform arbitrary precision integer division
printf '%s / %s\n' "${1#+}" "${2#+}" | bc