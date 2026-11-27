#!/bin/sh -e

REPO_URL="https://github.com/esnet/iperf.git"
TAG="3.22.1"
CHECKOUT_PATH="iperf3"
SRC_PATH="Source/iperf3"
IOS_DEPLOYMENT_TARGET="15.0"

cd "$(dirname "$0")"

echo "Checking out $REPO_URL"
rm -rf "$CHECKOUT_PATH" && mkdir "$CHECKOUT_PATH"
git clone --quiet --depth 1 --single-branch "$REPO_URL" --branch "$TAG" "$CHECKOUT_PATH"

echo "Configuring the source files for iOS $IOS_DEPLOYMENT_TARGET"
(
    cd "$CHECKOUT_PATH"
    # Probe iOS APIs rather than the build Mac's APIs. Explicit build/host
    # values keep configure from attempting to execute its iOS test programs.
    # Apple's endian headers do not provide the BSD conversion macros expected
    # by iPerf. Select its existing libkern/OSByteOrder.h implementation instead.
    ac_cv_header_endian_h=no ac_cv_header_sys_endian_h=no \
    CC="$(xcrun --sdk iphoneos --find clang)" \
    CFLAGS="-target arm64-apple-ios${IOS_DEPLOYMENT_TARGET} -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -Werror=unguarded-availability-new" \
    ./configure --build="$(./config/config.guess)" --host=aarch64-apple-ios \
        --without-openssl > /dev/null
)

echo "Copying relevant source files"
cp "$CHECKOUT_PATH/LICENSE" LICENSE
[ ! -d "$SRC_PATH" ] && mkdir -p "$SRC_PATH"
cp "$CHECKOUT_PATH/src/"*.h "$SRC_PATH/"
cp "$CHECKOUT_PATH/src/"*.c "$SRC_PATH/"
rm "$SRC_PATH/main.c" "$SRC_PATH/t_"*.c
rm -rf "$CHECKOUT_PATH"

echo "$SRC_PATH is now updated to version $TAG!"
