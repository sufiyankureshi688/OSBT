#!/bin/bash
set -e

HAUL_HOME=$PWD/haiku-dev

mkdir -p $HAUL_HOME
cd $HAUL_HOME

# Clone Haiku buildtools and source if not present
[ ! -d buildtools ] && git clone https://review.haiku-os.org/buildtools
[ ! -d haiku ] && git clone https://review.haiku-os.org/haiku

# Configure cross-tools
cd haiku
mkdir -p generated.x86_64
cd generated.x86_64
../configure --cross-tools-source $HAUL_HOME/buildtools --build-cross-tools x86_64

# Build Haiku
jam -q @nightly-raw
