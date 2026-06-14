#!/usr/bin/env bash
cd $HOME/Build-Scripts 
if [ -f $HOME/reset-build-scripts-repo.sh ]; then
   bash $HOME/reset-build-scripts-repo.sh
else
   echo "cd $HOME" > $HOME/reset-build-scripts-repo.sh
   echo "mkdir -p Build-Scripts" >> $HOME/reset-build-scripts-repo.sh
   echo "git clone https://github.com/amidevous2/Build-Scripts.git Build-Scripts2" >> $HOME/reset-build-scripts-repo.sh
   echo "rm -rf $HOME/Build-Scripts/*" >> $HOME/reset-build-scripts-repo.sh
   echo "cp -R $HOME/Build-Scripts2/* $HOME/Build-Scripts/" >> $HOME/reset-build-scripts-repo.sh
   echo "rm -rf $HOME/Build-Scripts2/" >> $HOME/reset-build-scripts-repo.sh
   echo "cd $HOME/Build-Scripts" >> $HOME/reset-build-scripts-repo.sh
   bash $HOME/reset-build-scripts-repo.sh
fi
