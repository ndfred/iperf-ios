#!/bin/sh -e

REPO_URL="https://github.com/esnet/iperf.git"
TAG="3.1.4"
PACKAGE_VERSION="3.1"
CHECKOUT_PATH="iperf3"
SRC_PATH="Source/iperf3"

cd "`dirname "$0"`"
rm -rf "$CHECKOUT_PATH" && mkdir "$CHECKOUT_PATH"
git clone --quiet --depth 1 --single-branch "$REPO_URL" --branch "$TAG" "$CHECKOUT_PATH"
cp "$CHECKOUT_PATH/LICENSE" LICENSE
[ ! -d "$SRC_PATH" ] && mkdir -p "$SRC_PATH"
cp "$CHECKOUT_PATH/src/"*.h "$SRC_PATH/"
cp "$CHECKOUT_PATH/src/"*.c "$SRC_PATH/"
rm "$SRC_PATH/main.c"
cp "$CHECKOUT_PATH/src/version.h.in" "$SRC_PATH/version.h"
sed -i "" -e "s/@PACKAGE_VERSION@/$PACKAGE_VERSION/" "$SRC_PATH/version.h"
rm -rf "$CHECKOUT_PATH"
