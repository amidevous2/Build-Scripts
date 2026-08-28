#!/usr/bin/env bash

export LANG=fr_FR.UTF-8
export LANGUAGE=fr_FR

# Binaries
WGET_GZ=wget-1.25.0.tar.gz
UNISTR_GZ=libunistring-1.1.tar.gz
SSL_GZ=openssl-1.0.2u.tar.gz
PERL_GZ=perl-5.10.0.7z
TEXTTEMPLATE_GZ=Text-Template-1.45.tar.gz
PATH_GZ=patch-2.7.6.tar.gz

WGET_TAR=wget-1.25.0.tar
UNISTR_TAR=libunistring-1.1.tar
SSL_TAR=openssl-1.0.2u.tar
PERL_TAR=perl-5.10.0.tar
TEXTTEMPLATE_TAR=Text-Template-1.45.tar
PATH_TAR=patch-2.7.6.tar

WGET_DIR=wget-1.25.0
UNISTR_DIR=libunistring-1.1
SSL_DIR=openssl-1.0.2u
PERL_DIR=perl-5.10.0
TEXTTEMPLATE_DIR=Text-Template-1.45
PATH_DIR=patch-2.7.6

# Directories
BOOTSTRAP_DIR="$HOME/Build-Scripts/bootstrap"
PATCH_DIR="$HOME/Build-Scripts/patch"

# Install location
PREFIX="$HOME/.build-scripts/wget"
BINDIR="$PREFIX/bin"
CACERTDIR="$PREFIX/cacert"
CACERTFILE="$CACERTDIR/cacert.pem"

rm -rf $PREFIX
mkdir -p $PREFIX
if [[ "$(uname -m)" == "x86_64" ]]; then
mv 7z 7z.i386
mv 7z.x86_64 7z
mv 7z.so 7z.so.i386
mv 7z.so.x86_64 7z.so
mv 7zCon.sfx 7zCon.sfx.i386
mv 7zCon.sfx.x86_64 7zCon.sfx
mv 7za 7za.i386
mv 7za.x86_64 7za
gccfile=gcc-4.4.7-x86_64.7z.001
gccfilemin=gcc-4.4.7-x86_64.tar
LIBDIR="$PREFIX/lib64"
export CCPORABLE=$HOME/.local/gcc64/bin/x86_64-unknown-linux-gnu-gcc; CXXPORABLE=$HOME/.local/gcc64/bin/x86_64-unknown-linux-gnu-g++
else
gccfile=gcc-4.4.7-i686.7z.001
gccfilemin=gcc-4.4.7-i686.tar
LIBDIR="$PREFIX/lib"
export CCPORABLE=$HOME/.local/gcc32/bin/i686-unknown-linux-gnu-gcc; CXXPORABLE=$HOME/.local/gcc32/bin/i686-unknown-linux-gnu-g++
fi
chmod 777 $BOOTSTRAP_DIR/7z
chmod 777 $BOOTSTRAP_DIR/7z.so
chmod 777 $BOOTSTRAP_DIR/7zCon.sfx
chmod 777 $BOOTSTRAP_DIR/7za

export PKG_CONFIG_PATH="$LIBDIR/pkgconfig:$PREFIX/share/pkgconfig"

export CPPFLAGS="-I$PREFIX/include"
export CFLAGS="-I$PREFIX/include -O2"
export CXXFLAGS="-I$PREFIX/include -O2"
export LDFLAGS="-L$LIBDIR -Wl,-rpath,$LIBDIR"

export LD_LIBRARY_PATH="$LIBDIR"

# Sets the number of make jobs if not set in environment
: "${INSTX_JOBS:=2}"

# Make the directories
mkdir -p "$CACERTDIR"

###############################################################################

# Autotools on Solaris has an implied requirement for GNU gear. Things fall apart without it.
# Also see https://blogs.oracle.com/partnertech/entry/preparing_for_the_upcoming_removal.
if [[ -d "/usr/gnu/bin" ]]; then
    if [[ ! ("$PATH" == *"/usr/gnu/bin"*) ]]; then
        echo
        echo "Adding /usr/gnu/bin to PATH for Solaris"
        export PATH="/usr/gnu/bin:$PATH"
    fi
elif [[ -d "/usr/swf/bin" ]]; then
    if [[ ! ("$PATH" == *"/usr/sfw/bin"*) ]]; then
        echo
        echo "Adding /usr/sfw/bin to PATH for Solaris"
        export PATH="/usr/sfw/bin:$PATH"
    fi
elif [[ -d "/usr/ucb/bin" ]]; then
    if [[ ! ("$PATH" == *"/usr/ucb/bin"*) ]]; then
        echo
        echo "Adding /usr/ucb/bin to PATH for Solaris"
        export PATH="/usr/ucb/bin:$PATH"
    fi
fi
export PATH="$PREFIX/bin:$PATH"
############################## Misc ##############################




if [[ -z "$CC" ]]
then
    if [[ -n "$(command -v gcc 2>/dev/null)" ]]; then
        CC=gcc; CXX=g++ MAKE=make
    elif [[ -n "$(command -v clang 2>/dev/null)" ]]; then
        CC=clang; CXX=clang++ MAKE=make
    elif [[ -n "$(command -v cc 2>/dev/null)" && -n "$(command -v CC 2>/dev/null)" ]]; then
        CC=cc; CXX=CC MAKE=make
    else
	echo "remove old home"
	rm -rf "$HOME/.local/"
    mkdir -p "$HOME/.local/"
    cd "$HOME/.local/"
    cp $BOOTSTRAP_DIR/gcc-4.4.7-$(uname -m)* "$HOME/.local/"
    "$BOOTSTRAP_DIR/7z" x "$gccfile"
    rm -f "$gccfile"
    #find "$HOME/.local/" -type f -exec file {} \; | grep 'ELF .*executable' | cut -d: -f1 | xargs chmod +x
	#chmod +x $HOME/.local/bin/*
	chmod +x "$CCPORABLE"
	chmod +x "$CXXPORABLE"
    export CC="$CCPORABLE"
	export CXX="$CXXPORABLE"
	mkdir -p "$PREFIX/bin/"
	ln -s "$CCPORABLE" "$PREFIX/bin/gcc"
	ln -s "$CXXPORABLE" "$PREFIX/bin/g++"
    if [[ -f "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/libc-2.12.2.so" ]]; then
        rm -f "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/libc.so.6"
        cp "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/libc-2.12.2.so" \
       "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/libc.so.6"
    elif [[ -f "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/libc-2.12.2.so" ]]; then
        rm -f "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/libc.so.6"
        cp "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/libc-2.12.2.so" \
        "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/libc.so.6"
    fi
	hash -r
	export MAKE=make
    cd $BOOTSTRAP_DIR
    fi
else
	echo "remove old home"
   rm -rf "$HOME/.local/"
    mkdir -p "$HOME/.local/"
    cd "$HOME/.local/"
    cp $BOOTSTRAP_DIR/gcc-4.4.7-$(uname -m)* "$HOME/.local/"
    "$BOOTSTRAP_DIR/7z" x "$gccfile"
    rm -f "$gccfile"
   #find "$HOME/.local/" -type f -exec file {} \; | grep 'ELF .*executable' | cut -d: -f1 | xargs chmod +x
   chmod +x $HOME/.local/bin/*
	chmod +x "$CCPORABLE"
	chmod +x "$CXXPORABLE"
    export CC="$CCPORABLE"
	export CXX="$CXXPORABLE"
	mkdir -p "$PREFIX/bin/"
	ln -s "$CCPORABLE" "$PREFIX/bin/gcc"
	ln -s "$CXXPORABLE" "$PREFIX/bin/g++"	
    if [[ -f "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/libc-2.12.2.so" ]]; then
        rm -f "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/libc.so.6"
        cp "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/libc-2.12.2.so" \
       "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/libc.so.6"
    elif [[ -f "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/libc-2.12.2.so" ]]; then
        rm -f "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/libc.so.6"
        cp "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/libc-2.12.2.so" \
        "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/libc.so.6"
    fi    
	hash -r
	export MAKE=make
   cd $BOOTSTRAP_DIR
fi

if $CC $CFLAGS bitness.c -o /dev/null &>/dev/null; then
    OPT_BITS=64
else
    OPT_BITS=32
fi

if $CC $CFLAGS comptest.c -fPIC -o /dev/null &>/dev/null; then
    OPT_PIC=-fPIC
elif $CC $CFLAGS comptest.c -kPIC -o /dev/null &>/dev/null; then
    OPT_PIC=-kPIC
fi

# Needed for Solaris
if $CC $CFLAGS comptest.c -lresolv -lsocket -lnsl -o /dev/null &>/dev/null; then
    OPT_SOCKET="-lresolv -lsocket -lnsl"
elif $CC $CFLAGS comptest.c -lsocket -lnsl -o /dev/null &>/dev/null; then
    OPT_SOCKET="-lsocket -lnsl"
elif $CC $CFLAGS comptest.c -lsocket -o /dev/null &>/dev/null; then
    OPT_SOCKET="-lsocket"
fi

# Needed for some BSDs
if $CC $CFLAGS comptest.c -ldl -o /dev/null &>/dev/null; then
    OPT_LDL=-ldl
fi

echo
echo "*************************************************"
echo Bootstrap options:
echo "  OPT_BITS: $OPT_BITS"
echo "  OPT_PIC: $OPT_PIC"
echo "  OPT_LDL: $OPT_LDL"
echo "  OPT_SOCKET: $OPT_SOCKET"
echo "  GCC: $CC"
echo "  CXX: $CC"
echo "*************************************************"

IS_DARWIN=$(grep -i -c 'darwin' <<< "$(uname -s 2>&1)")
IS_LINUX=$(grep -i -c 'linux' <<< "$(uname -s 2>&1)")
IS_SOLARIS=$(grep -i -c 'sunos' <<< "$(uname -s 2>&1)")
IS_AMD64=$(grep -i -c -E 'x86_64|amd64' <<< "$(uname -m 2>&1)")
IS_ARM64=$(grep -i -c -E 'aarch64|arm64' <<< "$(uname -m 2>&1)")

# DH is 2x to 4x faster with ec_nistp_64_gcc_128, but it is
# only available on x64 machines with uint128 available.
HAVE_INT128=$($CC $CFLAGS -dM -E - </dev/null | grep -i -c "__SIZEOF_INT128__")

if [[ "$IS_AMD64" -ne 0 && "$HAVE_INT128" -ne 0 ]]; then
    OPT_INT128="enable-ec_nistp_64_gcc_128"
fi

# OpenSSL does not honor no-dso. Needed by Unistring and Wget.
OPENSSL_LIBS="$LIBDIR/libssl.a $LIBDIR/libcrypto.a"
UNISTRING_LIBS="$LIBDIR/libunistring.a"

############################## CA Certs ##############################

echo
echo "*************************************************"
echo "Configure CA certs"
echo "*************************************************"
echo

# Copy our copy of cacerts to bootstrap
mkdir -p "$CACERTDIR"
if ! cp cacert.pem "$CACERTDIR"; then
    echo "Failed to install cacert.pem"
    exit 1
fi

echo "Copy cacert.pem to $CACERTFILE"
echo "Done."

############################## Patch ##############################
if [ ! -f "$PREFIX/bin/patch" ]; then
cd $BOOTSTRAP_DIR
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$PATH_GZ
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$PATH_TAR
cd $PATH_DIR
chmod +x configure
echo CC=$CCPORABLE CXX=$CXXPORABLE
PATH=$PREFIX/bin:$PATH CC=$CCPORABLE CXX=$CXXPORABLE ./configure --prefix=$PREFIX --libdir=$LIBDIR
make
make install
echo patch build finish
sleep 30
fi
############################## bzip2 ##############################

if [ ! -f "$LIBDIR/pkgconfig/bzip2.pc" ]; then
cd "$BOOTSTRAP_DIR" || exit 1
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/bzip2-1.0.8.tar.gz
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/bzip2-1.0.8.tar
cd bzip2-1.0.8
patch -p1 < $PATCH_DIR/bzip-1.0.8.patch
PATH=$PREFIX/bin:$PATH CC=$CCPORABLE CXX=$CXXPORABLE make -f Makefile-libbz2_so
PATH=$PREFIX/bin:$PATH CC=$CCPORABLE CXX=$CXXPORABLE make bzip2recover
chmod 644 bzlib.h
mkdir -p $PREFIX/bin $LIBDIR/pkgconfig $PREFIX/include
cp -p bzlib.h $PREFIX/include
install -m 755 libbz2.so.1.0.8 $LIBDIR
install -m 644 libbz2.a $LIBDIR
install -m 644 bzip2.pc $LIBDIR/pkgconfig/bzip2.pc
install -m 755 bzip2-shared  $PREFIX/bin/bzip2
install -m 755 bzip2recover bzgrep bzdiff bzmore  $PREFIX/bin
rm -f $PREFIX/bin/bunzip2
ln -s bzip2 $PREFIX/bin/bunzip2
rm -f $PREFIX/bin/bzcat
ln -s bzip2 $PREFIX/bin/bzcat
rm -f ${INSTX_PREFIX}/bin/bzcmp
ln -s bzdiff $PREFIX/bin/bzcmp
rm -f $PREFIX/bin/bzless
ln -s bzmore $PREFIX/bin/bzless
rm -rf $PREFIX/bin/bzegrep
ln -s bzgrep $PREFIX/bin/bzegrep
rm -f $PREFIX/bin/bzfgrep
ln -s bzgrep$PREFIX/bin/bzfgrep
rm -f $PREFIX/bin/libbz2.so.1
ln -s libbz2.so.1.0.8 $PREFIX/bin/libbz2.so.1
rm -f $PREFIX/bin/libbz2.so
ln -s libbz2.so.1.0.8 $PREFIX/bin/libbz2.so

echo bzip2 build finish
sleep 30
fi

############################## zlib ##############################
if [ ! -f "$LIBDIR/pkgconfig/zlib.pc" ]; then
cd "$BOOTSTRAP_DIR" || exit 1
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/zlib-1.2.13.tar.gz
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/zlib-1.2.13.tar
cd zlib-1.2.13
chmod +x configure
ln -s $CCPORABLE $PREFIX/bin/gcc
ln -s $CXXPORABLE $PREFIX/bin/g++
PATH=$PREFIX/bin:$PATH CC=$CCPORABLE CXX=$CXXPORABLE ./configure --prefix=$PREFIX --libdir=$LIBDIR
make
make install

echo zlib build finish
sleep 30
fi

############################## Perl ##############################
if [ ! -f "$PREFIX/bin/perl" ]; then
cd "$BOOTSTRAP_DIR" || exit 1
#cd "$BOOTSTRAP_DIR"

echo
echo "*************************************************"
echo "Building Perl"
echo "*************************************************"
echo

rm -rf "$PERL_DIR" &>/dev/null
rm -f "$PERL_TAR"

cd "$BOOTSTRAP_DIR" || exit 1
"$BOOTSTRAP_DIR/7z" x "$BOOTSTRAP_DIR/$PERL_GZ"

cd "$BOOTSTRAP_DIR/$PERL_DIR" || exit 1

./Configure \
  -des \
  -Dprefix="$PREFIX" \
  -Dsiteprefix="$PREFIX" \
  -Dvendorprefix="$PREFIX" \
  -Duseshrplib \
  -Duseperlio \
  -Dcc="$CC" \
  -Doptimize="-O2 -fPIC" \
  -Dccflags="-O2 -fPIC -fno-strict-aliasing -pipe" \
  -Dldflags="-L$LIBDIR -Wl,-rpath,$LIBDIR -lm"
make
make install

echo perl build finish
sleep 30

cd "$BOOTSTRAP_DIR" || exit 1
fi

######################## Perl Text-Template ########################
if [ ! -f "$PREFIX/bin/openssl" ]; then

cd "$BOOTSTRAP_DIR" || exit 1

echo
echo "*************************************************"
echo "Building Perl Text-Template"
echo "*************************************************"
echo
cd $BOOTSTRAP_DIR
rm -rf "$TEXTTEMPLATE_DIR" &>/dev/null
rm -rf $TEXTTEMPLATE_TAR
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$TEXTTEMPLATE_GZ
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$TEXTTEMPLATE_TAR
cd "$BOOTSTRAP_DIR/$TEXTTEMPLATE_DIR" || exit 1
"$PREFIX/bin/perl" Makefile.PL PREFIX="$PREFIX"
make
make install


echo Perl Text-Template build finish
sleep 30
cd $BOOTSTRAP_DIR
fi

############################## OpenSSL ##############################
if [ ! -f "$PREFIX/bin/openssl" ]; then
cd "$BOOTSTRAP_DIR" || exit 1

echo
echo "*************************************************"
echo "Building OpenSSL"
echo "*************************************************"
echo
rm -rf "$SSL_DIR" &>/dev/null
rm -rf $SSL_TAR
cd $BOOTSTRAP_DIR
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$SSL_GZ
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$SSL_TAR
cd "$BOOTSTRAP_DIR/$SSL_DIR" || exit 1

cp "${PATCH_DIR}/openssl-1.0.2.patch" .

if ! patch -p0 < openssl-1.0.2.patch;
then
    echo "Failed to patch OpenSSL"
    exit 1
fi
chmod +x config
    KERNEL_BITS="$OPT_BITS" \
./config \
    --prefix="$PREFIX" \
    --openssldir="$PREFIX" \
    "$OPT_INT128" "$OPT_PIC" -DPEDANTIC \
    no-ssl2 no-ssl3 no-comp no-zlib no-zlib-dynamic \
    no-threads no-shared no-dso no-engine
chmod +x util/domd
chmod +x util/*
# This will need to be fixed for BSDs and PowerMac
make depend
#if ! make depend; then
#    echo "Failed to update OpenSSL dependencies"
#    exit 1
#fi

make -j "$INSTX_JOBS"
#if ! make -j "$INSTX_JOBS"; then
#    echo "Failed to build OpenSSL"
#    exit 1
#fi

rm -f "$PREFIX/openssl.cnf"

make install_sw
#if ! make install_sw; then
#    echo "Failed to install OpenSSL"
#    exit 1
#fi

# OpenSSL does not honor no-engines
rm -rf "$LIBDIR/engines"

# Write essential values
{
    echo "RANDFILE = \$ENV::HOME/.rand"
    echo "certificate = $CACERTDIR/cacert.pem"

} >> "$PREFIX/openssl.cnf"
echo openssl build finish
sleep 30
cd $BOOTSTRAP_DIR
#fi

############################## Unistring ##############################
if [ ! -f "$LIBDIR/pkgconfig/libunistring.pc" ]; then
cd "$BOOTSTRAP_DIR" || exit 1

echo
echo "*************************************************"
echo "Building Unistring"
echo "*************************************************"
echo

$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$UNISTR_GZ
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$UNISTR_TAR
cd "$BOOTSTRAP_DIR/$UNISTR_DIR" || exit 1

chmod +x configure
    CFLAGS="$CFLAGS" \
    LDFLAGS="$LDFLAGS" \
    PKG_CONFIG_PATH="$LIBDIR/pkgconfig/" \
    OPENSSL_LIBS="$OPENSSL_LIBS" \
    LIBS="$OPT_SOCKET $OPT_LDL" \
./configure \
    --prefix="$PREFIX" \
    --sysconfdir="$PREFIX/etc" \
    --disable-shared

if [[ "$?" -ne 0 ]]; then
    echo "Failed to configure Unistring"
    exit 1
fi

if ! make -j "$INSTX_JOBS" V=1; then
    echo "Failed to build Unistring"
    exit 1
fi

if ! make install; then
    echo "Failed to install Unistring"
    exit 1
fi


echo Unistring build finish
sleep 30
fi
############################## Wget ##############################
if [ ! -f $PREFIX/bin/wget ]; then


cd "$BOOTSTRAP_DIR" || exit 1

echo
echo "*************************************************"
echo "Building Wget"
echo "*************************************************"
echo

rm -rf "$WGET_DIR" &>/dev/null
rm -rf $WGET_TAR
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$WGET_GZ
$BOOTSTRAP_DIR/7z x $BOOTSTRAP_DIR/$WGET_TAR
cd "$BOOTSTRAP_DIR/$WGET_DIR" || exit 1
chmod +x configure
chmod +x doc/*.pl
chmod +x build-aux/* 2>/dev/null || true

cp "${PATCH_DIR}/wget.patch" .

patch -p0 < wget.patc
#if ! patch -p0 < wget.patch;
#then
#    echo "Failed to patch Wget"
#    exit 1
#fi

# Install recipe does not overwrite a config, if present.
if [[ -f "$PREFIX/etc/wgetrc" ]]; then
    rm "$PREFIX/etc/wgetrc"
fi

# Alpine Linux loader sucks...
lib_crypto=$(echo "$LIBDIR/libcrypto.a" | sed 's/\//\\\//g')
lib_ssl=$(echo "$LIBDIR/libssl.a" | sed 's/\//\\\//g')
lib_unistring=$(echo "$LIBDIR/libunistring.a" | sed 's/\//\\\//g')

sed -e "s/-lcrypto/$lib_crypto/g" \
    -e "s/-lssl/$lib_ssl/g" \
    -e "s/-lunistring/$lib_unistring/g" \
    configure > configure.fixed
mv configure.fixed configure && chmod +x configure

chmod 777 *
chmod -R 777 *
chmod +x configure
chmod +x ./texi2pod.pl
chmod +x doc/texi2pod.pl

    CFLAGS="$CFLAGS" \
    LDFLAGS="$LDFLAGS" \
    PKG_CONFIG_PATH="$LIBDIR/pkgconfig/" \
    OPENSSL_LIBS="$OPENSSL_LIBS" \
    LIBS="$OPT_SOCKET $OPT_LDL" \
./configure \
    --prefix="$PREFIX" \
    --sysconfdir="$PREFIX/etc" \
    --with-libunistring-prefix="${PREFIX}" \
    --with-libssl-prefix="${PREFIX}" \
    --with-ssl=openssl \
    --with-openssl=yes \
    --without-zlib \
    --without-libpsl \
    --without-libuuid \
    --without-libidn \
    --without-cares \
    --disable-pcre \
    --disable-pcre2 \
    --disable-nls \
    --disable-iri \
    --disable-ntlm \
    --disable-opie

if [[ "$?" -ne "0" ]]; then
    echo "Failed to configure Wget"
    exit 1
fi

# Fix makefiles. No shared objects.
IFS= find "$PWD" -iname 'Makefile' -print | while read -r file
do
    sed -e "s/-lcrypto/$lib_crypto/g" \
        -e "s/-lssl/$lib_ssl/g" \
        -e "s/-lunistring/$lib_unistring/g" \
        "${file}" > "${file}.fixed"
    mv "${file}.fixed" "${file}"
done
chmod +x ./texi2pod.pl
chmod +x doc/texi2pod.pl
# Fix lib/malloc/dynarray-skeleton.c
file=lib/malloc/dynarray-skeleton.c
sed -e 's/__nonnull ((1))//g' \
    -e 's/__nonnull ((1, 2))//g' \
    "${file}" > "${file}.fixed"
mv "${file}.fixed" "${file}"

if ! make -j "$INSTX_JOBS" V=1; then
    echo "Failed to build Wget"
    exit 1
fi
chmod +x ./texi2pod.pl
chmod +x doc/texi2pod.pl

# Remove old rc file.
rm -f "$PREFIX/etc/wgetrc"

if ! make install; then
    echo "Failed to install Wget"
    exit 1
fi

# Wget configuration file
{
    echo ""
    echo "# cacert.pem location"
    echo "ca_directory = $PREFIX/cacert/"
    echo "ca_certificate = $PREFIX/cacert/cacert.pem"
    echo ""
} >> "$PREFIX/etc/wgetrc"
fi


# Cleanup
if true; then
    cd "$BOOTSTRAP_DIR" || exit 1
    rm -rf "$WGET_DIR"
    rm -rf "$UNISTR_DIR"
    rm -rf "$SSL_DIR"
    rm -f openssl-1.0.2.patch
    rm -f wget.patch
fi

exit 0
