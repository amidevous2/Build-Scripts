#!/usr/bin/env bash

# Written and placed in public domain by Jeffrey Walton
# This script builds OpenVPN and its dependencies from sources.


PKG_NAME=openvpn
PKG_VER=2.5.5
PKG_TAR=${PKG_NAME}-${PKG_VER}.tar.gz
PKG_DIR=${PKG_NAME}-${PKG_VER}
PKG_URL="https://swupdate.openvpn.org/community/releases"
echo "${PKG_NAME} ${PKG_VER} ${PKG_URL} ${PKG_TAR} ${PKG_DIR}"
###############################################################################

# Get the environment as needed.
if [[ "${SETUP_ENVIRON_DONE}" != "yes" ]]; then
    if ! source ./setup-environ.sh
    then
        echo "Failed to set environment"
        exit 1
    fi
fi

# The password should die when this subshell goes out of scope
if [[ "${SUDO_PASSWORD_DONE}" != "yes" ]]; then
    if ! source ./setup-password.sh
    then
        echo "Failed to process password"
        exit 1
    fi
fi

###############################################################################

if ! ./build.sh cacert
then
    echo "Failed to install CA Certs"
    exit 1
fi

###############################################################################

if ! ./build.sh zlib
then
    echo "Failed to build zLib"
    exit 1
fi

###############################################################################

if ! ./build.sh openssl
then
    echo "Failed to build OpenSSL"
    exit 1
fi

###############################################################################

echo ""
echo "========================================"
echo "====== ${PKG_NAME} v${PKG_VER}  ====="
echo "========================================"

echo "${PKG_NAME} ${PKG_VER} ${PKG_URL} ${PKG_TAR} ${PKG_DIR}"


echo ""
echo "**********************"
echo "Downloading package"
echo "**********************"

if ! "${WGET}" -q -O "${PKG_TAR}" \
     "$PKG_URL/${PKG_TAR}"
then
    echo "Failed to download OpenVPN"
    exit 1
fi

echo "${PKG_NAME} ${PKG_VER} ${PKG_URL} ${PKG_TAR} ${PKG_DIR}"


rm -rf "${PKG_DIR}" &>/dev/null
gzip -d < "${PKG_TAR}" | tar xf -
cd "${PKG_DIR}"

if [[ -e ../patch/openvpn.patch ]]; then
    patch -u -p0 < ../patch/openvpn.patch
    echo ""
fi

# Fix sys_lib_dlsearch_path_spec
bash "${INSTX_TOPDIR}/fix-configure.sh"

    PKG_CONFIG_PATH="${INSTX_PKGCONFIG}" \
    CPPFLAGS="${INSTX_CPPFLAGS}" \
    ASFLAGS="${INSTX_ASFLAGS}" \
    CFLAGS="${INSTX_CFLAGS}" \
    CXXFLAGS="${INSTX_CXXFLAGS}" \
    LDFLAGS="${INSTX_LDFLAGS}" \
    LIBS="${INSTX_LDLIBS}" \
./configure \
    --build="${AUTOCONF_BUILD}" \
    --prefix="${INSTX_PREFIX}" \
    --libdir="${INSTX_LIBDIR}" \
    --with-crypto-library=openssl \
    --disable-lzo \
    --disable-lz4 \
    --disable-plugin-auth-pam

if [[ "$?" -ne 0 ]]; then
    echo "Failed to configure OpenVPN"
    exit 1
fi

echo "**********************"
echo "Building package"
echo "**********************"

MAKE_FLAGS=("-j" "${INSTX_JOBS}")
if ! "${MAKE}" "${MAKE_FLAGS[@]}"
then
    echo "Failed to build OpenVPN"
    exit 1
fi

echo "**********************"
echo "Testing package"
echo "**********************"

MAKE_FLAGS=("check")
if ! "${MAKE}" "${MAKE_FLAGS[@]}"
then
    echo "Failed to build OpenVPN"
    exit 1
fi

echo "**********************"
echo "Installing package"
echo "**********************"

MAKE_FLAGS=("install")
if [[ -n "${SUDO_PASSWORD}" ]]; then
    printf "%s\n" "${SUDO_PASSWORD}" | sudo ${SUDO_ENV_OPT} -S "${MAKE}" "${MAKE_FLAGS[@]}"
    printf "%s\n" "${SUDO_PASSWORD}" | sudo ${SUDO_ENV_OPT} -S bash "${INSTX_TOPDIR}/fix-permissions.sh" "${INSTX_PREFIX}"
else
    "${MAKE}" "${MAKE_FLAGS[@]}"
    bash "${INSTX_TOPDIR}/fix-permissions.sh" "${INSTX_PREFIX}"
fi

###############################################################################

echo ""
echo "*****************************************************************************"
echo "Please run Bash's 'hash -r' to update program cache in the current shell"
echo "*****************************************************************************"

###############################################################################

touch "${INSTX_PKG_CACHE}/${PKG_NAME}"

cd "${CURR_DIR}" || exit 1

###############################################################################
echo "${PKG_NAME} ${PKG_VER} ${PKG_URL} ${PKG_TAR} ${PKG_DIR}"

# Set to false to retain artifacts
rm -rf "${PKG_NAME}-${PKG_VER}" "${PKG_TAR}"

exit 0
