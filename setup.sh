#!/usr/bin/env bash
cd $HOME/
cat > $HOME/setup-build-scripts-repo.sh <<EOF
#!/usr/bin/env bash
cd $HOME
mkdir -p Build-Scripts
git clone https://github.com/amidevous2/Build-Scripts.git -b php56 Build-Scripts2
rm -rf $HOME/Build-Scripts/*
cp -R $HOME/Build-Scripts2/* $HOME/Build-Scripts/
rm -rf $HOME/Build-Scripts2/
#rm -rf $HOME/.build-scripts/*
cd $HOME/Build-Scripts
chmod +x *
if [ ! -d $HOME/.build-scripts/]; then
./setup-cacerts.sh
./setup-wget.sh
./setup-bash.sh
fi
INSTX_PREFIX="$HOME/.local"
export INSTX_PREFIX
./build-base.sh
EOF
chmod +x $HOME/setup-build-scripts-repo.sh
bash $HOME/setup-build-scripts-repo.sh
