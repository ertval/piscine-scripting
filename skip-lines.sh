#!/usr/bin/env bash

set -eu

ls -l | awk 'NR % 2 == 1'
