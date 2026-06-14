#!/usr/bin/env bash

# Written and placed in public domain by Jeffrey Walton

# This script builds a handful of packages that are used by most GNU packages.
# The primary packages built by this script are Patchelf, Ncurses, Readline,
# iConvert and GetText.
#
# The primary packages have prerequisites, so secondary packages include
# libunistring, libxml2, PCRE2 and IDN2. GetText is rebuilt a final time
# after libunitstring and libxml2 are ready.
#
# GetText is the real focus of this script. GetText is built in two stages.
# First, the iConv/GetText pair is built due to circular dependency. Second,
# the final GetText is built which includes libunistring and libxml2.
#
# Most GNU packages will just call build-base.sh to get the common packages
# out of the way. Non-GNU packages can call the script, too.

PKG_NAME=gnu-base

###############################################################################

# PKG_NAME trick does not work here... Export INSTX_BASE_RECURSION_GUARD
# to avoid reentering this script for recipes like IDN2 and PCRE2.
# INSTX_BASE_RECURSION_GUARD goes out of scope when this shell dies.

if [[ "$INSTX_BASE_RECURSION_GUARD" == "yes" ]]; then
    exit 0
else
    INSTX_BASE_RECURSION_GUARD=yes
    export INSTX_BASE_RECURSION_GUARD
fi

###############################################################################

# Get the environment as needed.
if [[ "${SETUP_ENVIRON_DONE}" != "yes" ]]; then
    if ! source ./setup-environ.sh
    then
        echo "Failed to set environment"
        exit 1
    fi
fi

if [[ -e "${INSTX_PKG_CACHE}/${PKG_NAME}" ]]; then
    echo ""
    echo "$PKG_NAME is already installed."
    exit 0
fi

# The password should die when this subshell goes out of scope
if [[ "${SUDO_PASSWORD_DONE}" != "yes" ]]; then
    if ! source ./setup-password.sh
    then
        echo "Failed to process password"
        exit 1
    fi
fi

# GetText will be checked in build-gettext-final.sh
export INSTX_DISABLE_GETTEXT_CHECK=1

###############################################################################

if ! ./build.sh cacert
then
    echo "Failed to install CA Certs"
    exit 1
fi

###############################################################################

if ! ./build.sh ncurses-readline
then
    echo "Failed to build Ncurses and Readline"
    exit 1
fi

###############################################################################
echo "build Ncurses and Readline work"
sleep 10

if ! ./build.sh iconv-gettext
then
    echo "Failed to build iConv and GetText"
    exit 1
fi
echo "build iConv and GetText work"
sleep 10
###############################################################################

if ! ./build.sh unistr
then
    echo "Failed to build Unistring"
    exit 1
fi

echo "build Unistring work"
sleep 10
###############################################################################

if ! ./build.sh libxml2
then
    echo "Failed to build libxml2"
    exit 1
fi
echo "build libxml2 work"
sleep 10
###############################################################################

# GetText is checked in build-gettext-final.sh
unset INSTX_DISABLE_GETTEXT_CHECK

if ! ./build.sh gettext-final
then
    echo "Failed to build GetText final"
    exit 1
fi
echo "build GetText final work"
sleep 10
###############################################################################

# Trigger a rebuild of PCRE2

#rm -f "${INSTX_PKG_CACHE}/pcre2"

if ! ./build.sh pcre2
then
    echo "Failed to build PCRE2"
    exit 1
fi

echo "build pcre2 work"
sleep 10
###############################################################################

# Trigger a rebuild of IDN2

#rm -f "${INSTX_PKG_CACHE}/idn2"

if ! ./build.sh idn2
then
    echo "Failed to build IDN2"
    exit 1
fi

echo "build idn2 work"
sleep 10
###############################################################################

if ! ./build.sh zlib

then
    echo "Failed to build zlib"
    exit 1
fi

echo "build zlib work"
sleep 10
###############################################################################

if ! ./build.sh bzip

then
    echo "Failed to build bzip"
    exit 1
fi

echo "build bzip work"
sleep 10
###############################################################################

if ! ./build.sh unistr

then
    echo "Failed to build unistr"
    exit 1
fi

echo "build unistr work"
sleep 10
###############################################################################

#if ! ./build.sh bison

#then
#    echo "Failed to build bison"
#    exit 1
#fi

#echo "build bison work"
#sleep 10
###############################################################################

#if ! ./build.sh gdbm

#then
#    echo "Failed to build gdbm"
#    exit 1
#fi

#echo "build gdbm work"
#sleep 10
###############################################################################

#if ! ./build.sh bdb

#then
#    echo "Failed to build bdb"
#    exit 1
#fi

#echo "build bdb work"
#sleep 10
###############################################################################

#if ! ./build.sh sed

#then
#    echo "Failed to build sed"
#    exit 1
#fi

#echo "build sed work"
#sleep 10
################################################################################

#if ! ./build.sh perl

#then
#    echo "Failed to build perl"
#    exit 1
#fi

#echo "build perl work"
#sleep 10
###############################################################################

if ! ./build.sh openssl

then
    echo "Failed to build openssl"
    exit 1
fi

echo "build bzip work"
sleep 10
###############################################################################

if ! ./build.sh wget

then
    echo "Failed to build WGET"
    exit 1
fi

echo "build wget work"
sleep 10
###############################################################################

if ! ./build.sh bash

then
    echo "Failed to build BASH"
    exit 1
fi


echo "build bash work"
sleep 10
###############################################################################













touch "${INSTX_PKG_CACHE}/${PKG_NAME}"

exit 0
