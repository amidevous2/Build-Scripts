#!/usr/bin/env bash
cat > $HOME/reset-build-scripts-repo.sh <<EOF
#!/usr/bin/env bash
cd $HOME
mkdir -p Build-Scripts
git clone https://github.com/amidevous2/Build-Scripts.git -b php56 Build-Scripts2
rm -rf $HOME/Build-Scripts/*
cp -R $HOME/Build-Scripts2/* $HOME/Build-Scripts/
rm -rf $HOME/Build-Scripts2/
cd $HOME/Build-Scripts
chmod +x *
EOF
chmod +x $HOME/reset-build-scripts-repo.sh
bash $HOME/reset-build-scripts-repo.sh
