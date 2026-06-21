#!/usr/bin/env bash

# Handle argument count
case $# in
	0|1)
		echo "Error: two numbers must be provided."
		exit 1
		;;
esac

# Define whitespace characters
sp=' '
tab='	'
cr=$(printf '\r')

# Helper function to clean arguments (strip leading/trailing space, tab, carriage return)
clean_arg() {
	cleaned_val="$1"
	# Strip leading
	while true; do
		case $cleaned_val in
			"$sp"*|"$tab"*|"$cr"*) cleaned_val="${cleaned_val#?}" ;;
			*) break ;;
		esac
	done
	# Strip trailing
	while true; do
		case $cleaned_val in
			*"$sp"|*"$tab"|*"$cr") cleaned_val="${cleaned_val%?}" ;;
			*) break ;;
		esac
	done
}

clean_arg "$1"; arg1="$cleaned_val"
clean_arg "$2"; arg2="$cleaned_val"

# Validate integers (optional single + or -, followed by digits)
for arg in "$arg1" "$arg2"; do
	case $arg in
		[0-9] | [0-9][0-9]* | [-+][0-9] | [-+][0-9][0-9]*)
			# Valid integer
			;;
		*)
			echo "Error: both arguments must be integers."
			exit 1
			;;
	esac
done

# Check for division by zero (any representation of zero: 0, -0, +0, 00, -00, etc.)
case $arg2 in
	*[1-9]*)
		;;
	*)
		echo "Error: division by zero is not allowed."
		exit 1
		;;
esac

# Perform arbitrary precision integer division (strip leading plus to avoid bc syntax error)
printf '%s / %s\n' "${arg1#+}" "${arg2#+}" | bc