#!/bin/bash

nohup cat facts </dev/null | grep "moon" | while read -r line; do
	echo "$line"
	echo "The moon fact was found!" >> output.txt
done &
