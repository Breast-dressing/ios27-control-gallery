#!/usr/bin/env bash
# 用 swift-api-digester dump SwiftUI 符号，再根据关键词筛出候选 API。
set -uo pipefail

APP=/Applications/Xcode_27.2.app
sudo xcode-select -s "$APP"
SDK=$(xcrun --sdk iphoneos --show-sdk-path)
echo "SDK=$SDK"
echo "xcodebuild: $(xcodebuild -version | tr '\n' ' ')"

MODDIR="$SDK/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule"
echo "== module dir =="
ls "$MODDIR" | head -20
for f in "$MODDIR"/*.swiftinterface; do [ -f "$f" ] && wc -l "$f"; done

JSON=/tmp/swiftui.json
echo "== api digester =="
xcrun swift-api-digester -dump-sdk \
  -module SwiftUI \
  -o "$JSON" \
  -target arm64-apple-ios27.2 \
  -sdk "$SDK" 2>&1 | tail -8
ls -lh "$JSON" 2>/dev/null || echo "dump failed"

if [ -s "$JSON" ]; then
  echo "== names matching keywords =="
  grep -oE '"name" : "[^"]*"' "$JSON" | sed 's/"name" : //' | grep -iE 'tick|counter|dial|knob|wheel|numeric|slider|gauge|stepper|shutter|camera' | sort -u | head -120
  echo ""
  echo "== decl fragments =="
  grep -oE '"printedName" : "[^"]*"' "$JSON" | sed 's/"printedName" : //' | grep -iE 'tick|counter|dial|knob|numeric' | sort -u | head -80
fi
