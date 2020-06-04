#!/usr/bin/env bash

file_type="${1}"
path="${2}"

echo $file_type
echo $path

time=$(date)
echo "::set-output name=time::$time"
