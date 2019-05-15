#!/bin/sh -e

cd "`dirname "$0"`"
xcrun llvm-profdata show iperf.profdata
