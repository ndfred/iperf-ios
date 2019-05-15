#!/bin/sh -e

cd "`dirname "$0"`"
xcrun llvm-profdata show -topn=50 iperf.profdata
