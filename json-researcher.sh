#!/usr/bin/env bash

data=$(curl -s "https://platform.zone01.gr/assets/superhero/all.json") && jq '.[] | select(.id == 1)' <<< "$data" | grep -E '"name"|"power"'
