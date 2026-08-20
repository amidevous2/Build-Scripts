#!/bin/bash
rougefonce='\e[0;31m'
neutre='\e[0;m'
script=$1
minfolder=$(echo $neutre "$script" | cut -c -1)
chmod +x build/$minfolder/$script.sh
build/$minfolder/$script.sh

echo -e "${rougefonce}*****************************************************************************"
echo -e "${rougefonce}****************************Build $script finished"
echo -e "${rougefonce}**Please run Bash's 'hash -r' to update program cache in the current shell"
echo -e "${rougefonce}*****************************************************************************"
hash -r

Nombre=0
while [ $Nombre -le 5000 ]
do
    echo "Please Wait : $Nombre seconds total 5000 seconds"
    ((Nombre++))
done
