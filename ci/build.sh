#!/usr/bin/env bash
# Build & Test 的实际逻辑：所有设置从 .ios-ci.yml 读取，工具链固定 Xcode 27.2。
# 注意：test/archive 两个阶段都输出完整日志，便于失败时直接从 ci.log 定位。
set -euo pipefail

OUT=build/out
mkdir -p "$OUT"

PROJECT=$(yq -r '.project' .ios-ci.yml)
SCHEME=$(yq -r '.scheme' .ios-ci.yml)
BUNDLE_ID=$(yq -r '.bundle_id' .ios-ci.yml)
XCODE=$(yq -r '.toolchain.xcode' .ios-ci.yml)
SIMULATOR=$(yq -r '.toolchain.simulator' .ios-ci.yml)
IOS=$(yq -r '.toolchain.ios' .ios-ci.yml)
GENERATE=$(yq -r '.generate_command' .ios-ci.yml)

echo "== config =="
echo "project=$PROJECT scheme=$SCHEME bundle=$BUNDLE_ID xcode=$XCODE sim=$SIMULATOR ios=$IOS generate=$GENERATE"

echo "== xcode =="
APP="/Applications/Xcode_${XCODE}.app"
if [ ! -d "$APP" ]; then
  echo "!! $APP missing; installed:"
  ls -1 /Applications | grep -i xcode || true
  exit 1
fi
sudo xcode-select -s "$APP"
xcodebuild -version || true
xcrun --sdk iphoneos --show-sdk-version || true
xcrun --sdk iphonesimulator --show-sdk-version || true

echo "== xcodegen =="
if [[ "$GENERATE" == *xcodegen* ]]; then
  curl -fLsS https://github.com/yonaskolb/XcodeGen/releases/download/2.46.0/xcodegen.zip -o "$RUNNER_TEMP/xcodegen.zip"
  echo "4d9e34b62172d645eed6457cac13fc222569974098ef4ee9c3368bedf0196806  $RUNNER_TEMP/xcodegen.zip" | shasum -a 256 -c -
  unzip -oq "$RUNNER_TEMP/xcodegen.zip" -d "$RUNNER_TEMP"
  export PATH="$RUNNER_TEMP/xcodegen/bin:$PATH"
  xcodegen --version
fi

echo "== generate =="
bash -e -c "$GENERATE"
test -d "$PROJECT" || { echo "!! $PROJECT not generated"; exit 1; }

echo "== test =="
set +e
xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,name=$SIMULATOR,OS=$IOS" \
  -derivedDataPath build/DerivedData \
  -resultBundlePath "$OUT/Test.xcresult" \
  CODE_SIGNING_ALLOWED=NO
TEST_EXIT=$?
set -e
echo "test exit=$TEST_EXIT"
echo "$TEST_EXIT" > "$OUT/test-exit.txt"

echo "== archive =="
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath build/App.xcarchive \
  -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGN_ENTITLEMENTS="" \
  ENABLE_BITCODE=NO

echo "== package =="
APP_PATH="build/App.xcarchive/Products/Applications/${SCHEME}.app"
test -d "$APP_PATH" || { echo "!! $APP_PATH missing"; ls -R build/App.xcarchive/Products || true; exit 1; }
BID=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP_PATH/Info.plist")
echo "CFBundleIdentifier=$BID"
test "$BID" = "$BUNDLE_ID" || { echo "!! bundle id mismatch"; exit 1; }

rm -rf build/ipa && mkdir -p build/ipa/Payload
cp -R "$APP_PATH" build/ipa/Payload/
cd build/ipa
zip -qry "../ControlGallery-unsigned.ipa" Payload
cd ../..
unzip -l build/ControlGallery-unsigned.ipa
ls -lh build/ControlGallery-unsigned.ipa
codesign -dv "$APP_PATH" 2>&1 || echo "unsigned (expected)"
