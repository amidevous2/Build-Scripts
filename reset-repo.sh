#!/usr/bin/env bash
cat > $HOME/reset-build-scripts-repo.sh <<EOF
#!/usr/bin/env bash
cd $HOME
if command -v curl >/dev/null 2>&1; then DL="curl --insecure -fsSL"; else DL="wget --no-check-certificate -qO-"; fi
if ! command -v jq >/dev/null 2>&1; then JQ_VERSION=1.6; $DL "https://github.com/jqlang/jq/releases/download/jq-$JQ_VERSION/jq-$([ "$ARCH" = x86_64 ] && echo linux64 || echo linux32)" > "$PREFIX/bin/jq"; chmod 755 "$PREFIX/bin/jq"; fi
COMMIT=$($DL "https://api.github.com/repos/amidevous2/Build-Scripts/commits/php56" | jq -r .sha)
mkdir -p Build-Scripts
wget https://github.com/amidevous2/Build-Scripts/archive/$COMMIT.tar.gz -O Build-Scripts.targ.gz
tar -xvf Build-Scripts.targ.gz
#git clone https://github.com/amidevous2/Build-Scripts.git -b php56 Build-Scripts2
rm -rf $HOME/Build-Scripts/*
cp -R $HOME/Build-Scripts-php56/* $HOME/Build-Scripts/
rm -rf $HOME/Build-Scripts-php56/ Build-Scripts.targ.gz
cd $HOME/Build-Scripts
chmod +x *
EOF
chmod +x $HOME/reset-build-scripts-repo.sh
bash $HOME/reset-build-scripts-repo.sh
