#!/bin/bash

set -e

file_type="${1}"
path="${2}"

echo "parameter:"
echo "command: $*"
echo "arg1: $file_type"
echo "arg2: $path"

time=$(date)
echo ::set-output name=time::$time
