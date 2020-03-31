#!/bin/sh

# Update this whenever new release of custom electron is being built
release=v2

# decrypt the google app credentials
openssl aes-256-cbc -K $encrypted_04312af897a1_key -iv $encrypted_04312af897a1_iv -in marlobot-da901a2de0a5.json.enc -out marlobot-da901a2de0a5.json -d
export GOOGLE_APPLICATION_CREDENTIALS="./marlobot-da901a2de0a5.json"

# sync down all electron chromium dependencies
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

# build electron
echo "finished gclient sync, running electron build"
cd .. 
# current dir: src/
export CHROMIUM_BUILDTOOLS_PATH=`pwd`/buildtools
gn gen out/Release --args="import(\"//electron/build/args/release.gn\")"
ninja -C out/Release electron
ninja -C out/Release electron:electron_dist_zip
ls out/Release

# upload dist.zip and hash of dist zip to google cloud
md5 out/Release/dist.zip >> out/Release/dist.zip.md5sum
echo "uploading dist.zip to cloud"
pip install --upgrade google-cloud-storage
python upload_electron.py $release out/Release/dist.zip out/Release/dist.zip.md5sum
