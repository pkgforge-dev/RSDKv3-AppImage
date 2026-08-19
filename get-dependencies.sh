#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake     \
    glew      \
    libdecor  \
    libtheora \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building RSDKv3 Decompilation..."
echo "---------------------------------------------------------------"
REPO="https://github.com/RSDKModding/RSDKv3-Decompilation"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./RSDKv3
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./RSDKv3
cmake -S ./ -B build -D CMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
mv -v ./build/RSDKv3 ../AppDir/bin
