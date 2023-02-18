#!/usr/bin/env bash

threshold=10
diskData=$(df -bg)
diskArr=($diskData)
freeSpace=${diskArr[10]}

# Check threshold

if [ $1 ] && ! [[ $1 =~ ^[0-9]+$ ]]
then
    echo "Incorrect treshold"
    exit 1
elif [ $1 ]
then
    threshold=$1
fi

# Check free space

if [ $freeSpace -lt $threshold ]
then
    echo "Free space drops below a threshold ($threshold GB)"
else
    echo "Everything OK"
fi
