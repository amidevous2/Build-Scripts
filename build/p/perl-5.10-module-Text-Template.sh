#!/usr/bin/env bash

# Written by amidevous and chat gpt 
# perl 5.10.0 build module Text-Template version


PKG_NAME=Text-Template
TEXTTEMPLETE_VER=1.45
TEXTTEMPLETE_TAR=${PKG_NAME}-${TEXTTEMPLETE_VER}.tar.gz
TEXTTEMPLETE_DIR=${PKG_NAME}-${TEXTTEMPLETE_VER}

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

if ! ./build.sh perl-5.10.0
then
    echo "Failed to install perl 5.10.0"
    exit 1
fi

###############################################################################

echo ""
echo "=========================================="
echo "= Perl 5.10.0 Module Text-Template v${TEXTTEMPLETE_VER} ="
echo "=========================================="

echo ""
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@ Warning: Perl does not handle rpaths and runpaths properly. @@"
echo "@@ The wrong libraries will likely be loaded during runtime.   @@"
echo "@@ Also see https://github.com/Perl/perl5/issues/17534,        @@"
echo "@@ https://github.com/Perl/perl5/issues/18467, and             @@"
echo "@@ https://github.com/Perl/perl5/issues/18468.                 @@"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo ""
echo "************************"
echo "Downloading package"
echo "************************"

echo ""
echo "Perl 5.10.0 Module Text-Template v${TEXTTEMPLETE_VER}..."

if ! "${WGET}" -q -O "$TEXTTEMPLETE_TAR" \
     "https://github.com/amidevous2/Build-Scripts/releases/download/download/$TEXTTEMPLETE_TAR"
then
    echo "Failed to download Text-Template"
    exit 1
fi

rm -rf "$TEXTTEMPLETE_DIR" &>/dev/null
gzip -d < "$TEXTTEMPLETE_TAR" | tar xf -
cd "$TEXTTEMPLETE_DIR" || exit 1

echo ""
echo "************************"
echo "Configuring package"
echo "************************"


    CC="${CC}" \
    CXX="${CXX}" \
    PKGCONFIG="${INSTX_PKGCONFIG}" \
    CPPFLAGS="${INSTX_CPPFLAGS}" \
    ASFLAGS="${INSTX_ASFLAGS}" \
    CFLAGS="${INSTX_CFLAGS}" \
    CXXFLAGS="${INSTX_CXXFLAGS}" \
    LDFLAGS="${INSTX_LDFLAGS}" \
    LDLIBS="${opt_libm} ${INSTX_LDLIBS}" \
    LIBS="${opt_libm} ${INSTX_LDLIBS}" \
   "${INSTX_PREFIX}/bin/perl" Makefile.PL PREFIX="${INSTX_PREFIX}"

if [[ "$?" -ne 0 ]]; then
    echo "**************************************"
    echo "Failed to configure Text-Template v${TEXTTEMPLETE_VER}"
    echo "**************************************"

    bash "${INSTX_TOPDIR}/collect-logs.sh" "${PKG_NAME}"
    exit 1
fi

echo ""
echo "************************"
echo "Building package"
echo "************************"

# Perl has a problem with parallel builds on some paltforms.
MAKE_FLAGS=("-j" "1")

if ! "${MAKE}" "${MAKE_FLAGS[@]}"
then
    echo "**************************************"
    echo "Failed to build Text-Template v${TEXTTEMPLETE_VER}"
    echo "**************************************"

    bash "${INSTX_TOPDIR}/collect-logs.sh" "${PKG_NAME}"
    exit 1
fi

# Fix flags in *.pc files
bash "${INSTX_TOPDIR}/fix-pkgconfig.sh"

# Fix runpaths
bash "${INSTX_TOPDIR}/fix-runpath.sh"

#echo "************************"
#echo "Testing package"
#echo "************************"

#MAKE_FLAGS=("check" "-j" "1")
#if ! "${MAKE}" "${MAKE_FLAGS[@]}"
#then
#    echo "************************"
#    echo "Failed to test Perl"
#    echo "************************"
#
#    bash "${INSTX_TOPDIR}/collect-logs.sh" "${PKG_NAME}"
#    exit 1
#fi

# Fix runpaths again
bash "${INSTX_TOPDIR}/fix-runpath.sh"

echo ""
echo "************************"
echo "Installing package"
echo "************************"

MAKE_FLAGS=("install")
if [[ -n "${SUDO_PASSWORD}" ]]; then
    printf "%s\n" "${SUDO_PASSWORD}" | sudo ${SUDO_ENV_OPT} -S "${MAKE}" "${MAKE_FLAGS[@]}"
    printf "%s\n" "${SUDO_PASSWORD}" | sudo ${SUDO_ENV_OPT} -S bash "${INSTX_TOPDIR}/fix-permissions.sh" "${INSTX_PREFIX}"
else
    "${MAKE}" "${MAKE_FLAGS[@]}"
    bash "${INSTX_TOPDIR}/fix-permissions.sh" "${INSTX_PREFIX}"
fi

# printf "%s\n" "${SUDO_PASSWORD}" | sudo ${SUDO_ENV_OPT} -S chown -R "$SUDO_USER:$SUDO_USER" "$HOME/.cpan"

###############################################################################

echo ""
echo "*****************************************************************************"
echo "Please run Bash's 'hash -r' to update program cache in the current shell"
echo "*****************************************************************************"

###############################################################################

touch "${INSTX_PKG_CACHE}/${PKG_NAME}"

cd "${CURR_DIR}" || exit 1

###############################################################################

# Set to false to retain artifacts
if true;
then
    ARTIFACTS=("$TEXTTEMPLETE_TAR" "$TEXTTEMPLETE_DIR")
    for artifact in "${ARTIFACTS[@]}"; do
        rm -rf "$artifact"
    done
fi

exit 0
