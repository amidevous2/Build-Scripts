#!/usr/bin/env bash
cd $HOME/
cat > $HOME/setup-build-scripts-repo.sh <<EOF
#!/usr/bin/env bash
cd $HOME
mkdir -p Build-Scripts
cd $HOME
if command -v curl >/dev/null 2>&1; then DL2="curl --insecure -fL -o $1"; else DL2="wget --no-check-certificate -O $1"; fi
export LANG=fr_FR.UTF-8
export LANGUAGE=fr_FR
cd $HOME
mkdir -p $HOME/Build-Scripts
$DL2 Build-Scripts.targ.gz https://github.com/amidevous2/Build-Scripts/archive/master.tar.gz
tar -xvf Build-Scripts.targ.gz
rm -rf $HOME/Build-Scripts/*
cp -R $HOME/Build-Scripts-*/* $HOME/Build-Scripts/
rm -rf $HOME/Build-Scripts-*/ Build-Scripts.targ.gz
cd $HOME/Build-Scripts
chmod +x *
./setup-cacerts.sh
./setup-wget.sh
#./setup-bash.sh
INSTX_PREFIX="$HOME/.local"
export INSTX_PREFIX
PATH=$HOME/.build-scripts/wget/bin:$HOME/.local/bin
#./build-base.sh
EOF
chmod +x $HOME/setup-build-scripts-repo.sh
bash $HOME/setup-build-scripts-repo.sh
