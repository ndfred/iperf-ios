#!/bin/sh -e

REPO_URL="https://github.com/esnet/iperf.git"
TAG="3.1.4"
CHECKOUT_PATH="iperf3"
SRC_PATH="Source/iperf3"

cd "`dirname "$0"`"

echo "Checking out $REPO_URL"
rm -rf "$CHECKOUT_PATH" && mkdir "$CHECKOUT_PATH"
git clone --quiet --depth 1 --single-branch "$REPO_URL" --branch "$TAG" "$CHECKOUT_PATH"

echo "Configuring the source files"
pushd "$PWD"
cd "$CHECKOUT_PATH"
./configure > /dev/null
popd

echo "Copying relevant source files"
cp "$CHECKOUT_PATH/LICENSE" LICENSE
[ ! -d "$SRC_PATH" ] && mkdir -p "$SRC_PATH"
cp "$CHECKOUT_PATH/src/"*.h "$SRC_PATH/"
cp "$CHECKOUT_PATH/src/"*.c "$SRC_PATH/"
rm "$SRC_PATH/main.c" "$SRC_PATH/t_"*.c
rm -rf "$CHECKOUT_PATH"

echo "$SRC_PATH is now updated to version $TAG!"
