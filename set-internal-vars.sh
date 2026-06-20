#!/usr/bin/env bash

MY_MESSAGE="Hello World"
MY_NUM=100
MY_PI=3.142
MY_ARR=(one two three four five)

echo "$MY_MESSAGE"
echo "$MY_NUM"
echo "$MY_PI"
printf '%s' "${MY_ARR[0]}"
printf ', %s' "${MY_ARR[@]:1}"
printf '\n'
