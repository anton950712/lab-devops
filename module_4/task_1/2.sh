#!/usr/bin/env bash

path="$PWD"

# Check path

if [ $1 ]
then
    path=$1
fi

echo "Amount of files in the directory: $(find $path -type f | wc -l)"
