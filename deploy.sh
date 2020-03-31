#!/bin/sh

current_path=`pwd`
echo $current_path
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:$current_path/depot_tools
echo $PATH
mkdir electron-gn && cd electron-gn
gclient config --name "src/electron" --unmanaged https://github.com/getmarlo/electron
gclient sync --with_branch_heads --with_tags

cd src/electron
git checkout v8.1.2
gclient sync -f

cd ..
export CHROMIUM_BUILDTOOLS_PATH=`pwd`/buildtools
gn gen out/Release --args="import(\"//electron/build/args/release.gn\")
ninja -C out/Release electron
ninja -C out/Release electron:electron_dist_zip
