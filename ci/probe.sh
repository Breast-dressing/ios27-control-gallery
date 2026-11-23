#!/usr/bin/env bash
# 在 SwiftUI 的 arm64e swiftinterface 里检索候选 API。
set -uo pipefail

APP=/Applications/Xcode_27.2.app
sudo xcode-select -s "$APP"
SDK=$(xcrun --sdk iphoneos --show-sdk-path)
MODDIR="$SDK/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule"
FI=$(find "$MODDIR" -name '*apple-ios.swiftinterface' | head -1)
echo "INTERFACE=$FI"
wc -l "$FI"

show() {
  echo ""
  echo "######## $1"
  grep -niE "$1" "$FI" | head -50
}

show 'tick'
show 'public struct .*Counter|public enum .*Counter'
show 'Dial|Knob|Shutter'
show 'numericText|contentTransition'
show 'Wheel|DialStyle|Dial.value'
show 'public struct Slider'
show 'pickerStyle.*wheel|WheelPicker'
