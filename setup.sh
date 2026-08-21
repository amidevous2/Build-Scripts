#!/usr/bin/env bash
cd $HOME/
cat > $HOME/setup-build-scripts-repo.sh <<EOF
#!/usr/bin/env bash
cd $HOME
mkdir -p Build-Scripts
DL="wget --no-check-certificate -qO-"
COMMIT=\$(\$DL "https://api.github.com/repos/amidevous2/Build-Scripts/commits/php56" | jq -r .sha)
mkdir -p Build-Scripts
wget https://github.com/amidevous2/Build-Scripts/archive/\$COMMIT.tar.gz -O Build-Scripts.targ.gz
tar -xvf Build-Scripts.targ.gz
rm -rf $HOME/Build-Scripts/*
cp -R $HOME/Build-Scripts-\$COMMIT/* $HOME/Build-Scripts/
rm -rf $HOME/Build-Scripts-\$COMMIT/ Build-Scripts.targ.gz
cd $HOME/Build-Scripts
chmod +x *
EOF
rm -rf $HOME/.build-scripts/
./setup-cacerts.sh
./setup-wget.sh
./setup-bash.sh
INSTX_PREFIX="$HOME/.local"
export INSTX_PREFIX
PATH=$HOME/.build-scripts/wget/bin:$HOME/.local/bin
#./build-base.sh
EOF
chmod +x $HOME/setup-build-scripts-repo.sh
bash $HOME/setup-build-scripts-repo.sh
