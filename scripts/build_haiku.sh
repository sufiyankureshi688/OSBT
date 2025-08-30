#!/bin/bash
set -e

# Install gdown
python3 -m pip install --quiet gdown

# Download Haiku ZIP from Google Drive (large files supported)
gdown https://drive.google.com/uc?id=1jN423vDbJzPb0G9rmgGDi_HhbE73r_iI -O haiku.zip

# Unzip
unzip -q haiku.zip
cd haiku

# Install dependencies
sudo apt-get update
sudo apt-get install -y build-essential git automake autoconf \
    flex bison gawk texinfo gcc-multilib g++-multilib zlib1g-dev

# Build Haiku
./configure --build-cross-tools x86_64
jam -q haiku-image
