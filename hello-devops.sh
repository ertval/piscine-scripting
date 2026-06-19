#!/usr/bin/env bash

# Try to get username via gh cli
username=$(gh api user -q .login 2>/dev/null)

# If gh cli is not logged in or fails, try to parse from git remote origin
if [ -z "$username" ]; then
    remote_url=$(git config --get remote.origin.url 2>/dev/null)
    if [[ "$remote_url" =~ /git/([^/]+)/ ]]; then
        username="${BASH_REMATCH[1]}"
    elif [[ "$remote_url" =~ /([^/]+)/piscine-scripting ]]; then
        username="${BASH_REMATCH[1]}"
    fi
fi

# Fallback default if all else fails
if [ -z "$username" ]; then
    username="ekaramet"
fi

echo "Hello ${username}!"