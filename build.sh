#!/bin/bash
script=$1
minfolder=$(echo "$script" | cut -c -1)
chmod +x build/$minfolder/$script.sh
build/$minfolder/$script.sh
