#!/usr/bin/env bash
cd $HOME/Build-Scripts 
if [ -f $HOME/reset-build-scripts-repo.sh ]; then
   echo "cd $HOME" > $HOME/reset-build-scripts-repo.sh
   echo "rm -rf Build-Scripts" >> $HOME/reset-build-scripts-repo.sh
   echo "git clone https://github.com/amidevous2/Build-Scripts.git" >> $HOME/reset-build-scripts-repo.sh
   echo "cd $HOME/Build-Scripts" >> $HOME/reset-build-scripts-repo.sh
   echo "chmod +x *" >> $HOME/reset-build-scripts-repo.sh
fi
chmod +x $HOME/reset-build-scripts-repo.sh
$HOME/reset-build-scripts-repo.sh
