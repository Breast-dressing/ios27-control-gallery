#!/usr/bin/env bash
# 第二轮探针：① Slider 带刻度的 init 签名；② SwiftUICore 里的 numericText / contentTransition / Dial。
set -uo pipefail

APP=/Applications/Xcode_27.2.app
sudo xcode-select -s "$APP"
SDK=$(xcrun --sdk iphoneos --show-sdk-path)
SI=$(find "$SDK/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule" -name '*apple-ios.swiftinterface' | head -1)
CI=$(find "$SDK/System/Library/Frameworks/SwiftUICore.framework/Modules/SwiftUICore.swiftmodule" -name '*apple-ios.swiftinterface' | head -1)
echo "SI=$SI"
echo "CI=$CI"

sec() {
  echo ""
  echo "######## $1 ($2)"
  shift 2
  awk "NR>=$1 && NR<=$2" "$3" | grep -nE "init|struct|static" | head -40
}

sec "Slider 4993-5150" 4993 5150 "$SI"
sec "SliderTick 30170-30240" 30170 30240 "$SI"

echo ""
echo "######## Slider init with ticks"
grep -nE "public init.*ticks" "$SI" | head -20
grep -nE "ticks:" "$SI" | head -30

echo ""
echo "######## numericText / contentTransition in SwiftUICore"
[ -n "$CI" ] && grep -nE "numericText|ContentTransition|contentTransition" "$CI" | head -40

echo ""
echo "######## Dial / Counter / Tick in SwiftUICore"
[ -n "$CI" ] && grep -nE "Dial|Counter|SliderTick" "$CI" | head -20
