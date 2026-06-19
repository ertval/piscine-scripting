#!/usr/bin/env bash

set -eu

ls -l | sed -n '1~2p'
