#!/usr/bin/env bash
# 在 iOS 27.2 SDK 的 SwiftUI 接口文件里检索关键词，输出真实符号名与签名。
set -uo pipefail

APP=/Applications/Xcode_27.2.app
sudo xcode-select -s "$APP"
SDK=$(xcrun --sdk iphoneos --show-sdk-path)
echo "SDK=$SDK"
echo "xcodebuild: $(xcodebuild -version | tr '\n' ' ')"

FI=""
for c in "$SDK/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" "$SDK/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface"; do
  [ -f "$c" ] && FI="$c" && break
done
if [ -z "$FI" ]; then
  FI=$(find "$SDK/System/Library/Frameworks/SwiftUI.framework" -name '*arm64-apple-ios*.swiftinterface' | head -1)
fi
echo "INTERFACE=$FI"
[ -n "$FI" ] && wc -l "$FI"

search() {
  echo ""
  echo "===== $1 ====="
  grep -nE "$1" "$FI" 2>/dev/null | head -40
}

search 'struct Counter|class Counter|enum Counter'
search 'Counter[A-Za-z]*[ (]'
search 'tick'
search 'Tick'
search 'struct Dial|Dial[ (]|Knob|Wheel[ (]'
search 'numericText'
search 'struct Slider'
search 'Slider\(value'
search 'struct Gauge'
search 'camera|Camera|shutter|Shutter'
search 'struct Stepper|Stepper\(value'
