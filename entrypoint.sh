#!/bin/bash

echo "show $1 $2"

time=$(date)
echo "::set-output name=time::$time"
