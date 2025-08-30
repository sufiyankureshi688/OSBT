name: Build Haiku from Google Drive ZIP

on:
  workflow_dispatch:

jobs:
  build-haiku:
    runs-on: ubuntu-22.04

    steps:
      # Step 1: Checkout repository
      - name: Checkout repository
        uses: actions/checkout@v4

      # Step 2: Install dependencies
      - name: Install dependencies
        run: |
          sudo apt update
          sudo apt install -y python3-pip unzip git build-essential gcc g++ make \
            automake autoconf texinfo flex bison gawk nasm yasm pkg-config libtool \
            libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev

      # Step 3: Install gdown
      - name: Install gdown
        run: python3 -m pip install --quiet gdown

      # Step 4: Download Haiku source ZIP from Google Drive
      - name: Download Haiku source
        run: gdown https://drive.google.com/uc?id=1jN423vDbJzPb0G9rmgGDi_HhbE73r_iI -O haiku-source.zip

      # Step 5: Unzip Haiku source
      - name: Unzip Haiku source
        run: unzip haiku-source.zip -d haiku

      # Step 6: Clone buildtools if missing
      - name: Clone Haiku buildtools
        run: |
          mkdir -p haiku-dev
          cd haiku-dev
          [ ! -d buildtools ] && git clone https://review.haiku-os.org/buildtools

      # Step 7: Build Haiku
      - name: Build Haiku
        run: |
          cd haiku
          mkdir -p generated.x86_64
          cd generated.x86_64
          ../configure --cross-tools-source ../buildtools --build-cross-tools x86_64
          jam -q @nightly-raw

      # Step 8: Upload ISO artifact
      - name: Upload ISO artifact
        uses: actions/upload-artifact@v4
        with:
          name: haiku-iso
          path: haiku/generated.x86_64/obj/images
