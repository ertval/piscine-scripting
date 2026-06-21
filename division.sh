#!/bin/sh

case $# in
	0|1) echo "Error: two numbers must be provided."; exit 1 ;;
esac

for arg in "$1" "$2"; do
	case $arg in
		'' | - | *[!0-9-]* | -*[!0-9]* | *[0-9]-*)
			echo "Error: both arguments must be integers."
			exit 1 ;;
	esac
done

case $2 in
	*[1-9]*) ;;
	*) echo "Error: division by zero is not allowed."; exit 1 ;;
esac

printf '%s / %s\n' "$1" "$2" | bc