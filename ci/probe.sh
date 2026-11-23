#!/usr/bin/env bash
set -uo pipefail
APP=/Applications/Xcode_27.2.app
sudo xcode-select -s "$APP"
SDK=$(xcrun --sdk iphoneos --show-sdk-path)
SI=$(find "$SDK/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule" -name '*apple-ios.swiftinterface' | head -1)
echo "SI=$SI"

echo "######## SliderTick 30170-30230"
sed -n '30170,30230p' "$SI"

echo "######## Slider init 5000-5150 (first 30 init lines)"
sed -n '4993,5150p' "$SI" | grep -nE "init|struct Slider" | cut -c1-240 | head -25

echo "######## neutralValue / enabledBounds context"
grep -nE "neutralValue|enabledBounds" "$SI" | cut -c1-200 | head -20
