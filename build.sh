#!/bin/bash
rougefonce='\e[0;31m'
neutre='\e[0;m'
script=$1
minfolder=$(echo "$script" | cut -c -1)
chmod +x build/$minfolder/$script.sh
echo -e "${neutre}*****************************************************************************"
echo -e "${neutre}****************************Start Build $script"
echo -e "${neutre}*****************************************************************************"
build/$minfolder/$script.sh

echo -e "${rougefonce}*****************************************************************************"
echo -e "${rougefonce}****************************Build $script finished"
echo -e "${rougefonce}**Please run Bash's 'hash -r' to update program cache in the current shell"
echo -e "${rougefonce}*****************************************************************************"
hash -r

Nombre=0
while [ $Nombre -le 5 ]
do
    echo -e "${neutre}Please Wait : $Nombre minute on 5"
    sleep 1m
    ((Nombre++))
done
