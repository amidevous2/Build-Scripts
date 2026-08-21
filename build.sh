#!/bin/bash

rougefonce='\e[0;31m'
neutre='\e[0;m'
script=$1
minfolder=$(echo "$script" | cut -c -1)
chmod +x "build/$minfolder/$script.sh"
echo -e "${neutre}*****************************************************************************"
echo -e "${neutre}****************************Start Build $script"
echo -e "${neutre}*****************************************************************************"

if ! "build/$minfolder/$script.sh"; then
    echo -e "${rougefonce}**************************** Build $script FAILED ****************************"
    exit 1
fi

echo -e "${rougefonce}*****************************************************************************"
echo -e "${rougefonce}****************************Build $script finished"
echo -e "${rougefonce}**Please run Bash's 'hash -r' to update program cache in the current shell"
echo -e "${rougefonce}*****************************************************************************"
hash -r

echo -e "${neutre}."
