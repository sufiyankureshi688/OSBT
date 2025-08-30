#!/bin/bash
set -e

# File ID from Google Drive link
FILE_ID="1jN423vDbJzPb0G9rmgGDi_HhbE73r_iI"
DEST="haiku.zip"

echo "Downloading Haiku source from Google Drive..."
curl -L -c cookies.txt "https://drive.google.com/uc?export=download&id=${FILE_ID}" -o temp.html
CONFIRM=$(grep -o 'confirm=[^&]*' temp.html | head -n 1 | cut -d= -f2)
curl -L -b cookies.txt "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -o "${DEST}"

# Unzip source
unzip -q "${DEST}"
cd haiku

# Install build dependencies (Ubuntu runner)
sudo apt-get update
sudo apt-get install -y build-essential git automake autoconf \
    flex bison gawk texinfo gcc-multilib g++-multilib zlib1g-dev

# Configure and build
./configure --build-cross-tools x86_64
jam -q haiku-image
