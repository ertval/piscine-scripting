#!/usr/bin/env bash

data=$(curl -s "https://platform.zone01.gr/assets/superhero/all.json") && echo "$data" | jq '.[] | select(.id == 1)' | grep -E '"name"|"power"'
