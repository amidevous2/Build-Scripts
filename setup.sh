#!/usr/bin/env bash
rm -rf $HOME/.build-scripts/root-.local/*
chmod +x ./setup-cacerts.sh
./setup-cacerts.sh
chmod +x ./setup-wget.sh
./setup-wget.sh
chmod +x ./setup-bash.sh
./setup-bash.sh
chmod +x ./build-base.sh
chmod +x./build.sh wget
INSTX_PREFIX="$HOME/.local" ./build-base.sh
INSTX_PREFIX="$HOME/.local" ./build.sh wget
