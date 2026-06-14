#!/usr/bin/env bash
cd $HOME
rm -rf $HOME/.build-scripts/*
rm -rf Build-Scripts
git clone https://github.com/amidevous2/Build-Scripts.git -b php56 Build-Scripts
cd $HOME/Build-Scripts
chmod +x ./setup-cacerts.sh
./setup-cacerts.sh
chmod +x ./setup-wget.sh
./setup-wget.sh
chmod +x ./setup-bash.sh
./setup-bash.sh
chmod +x ./build-base.sh
chmod +x./build.sh wget
INSTX_PREFIX="$HOME/.local"
export INSTX_PREFIX
./build-base.sh
