#!/usr/bin/env bash

if [ $# -ne 2 ]; then
	echo "Error: two numbers must be provided."
elif ! [[ $1 =~ ^-?[0-9]+$ ]] || ! [[ $2 =~ ^-?[0-9]+$ ]]; then
	echo "Error: both arguments must be integers."
elif [ $(echo "$2 == 0" | bc) -eq 1 ]; then
	echo "Error: division by zero is not allowed."
else
	result=$(echo "$1 / $2" | bc)
	echo "$result"
fi