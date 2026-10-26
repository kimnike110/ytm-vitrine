#!/usr/bin/env bash
# Builds the WidgetKit Live Activity extension if Xcode / swiftc are available.
set -euo pipefail

DEST="${1:-out/YTLiveActivity.appex}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXT_SRC="$ROOT/extension/LiveActivity"

if ! command -v xcrun >/dev/null 2>&1; then
  echo "xcrun not found; skipping WidgetKit Live Activity compilation."
  exit 0
fi

SDK_PATH="$(xcrun --sdk iphoneos --show-sdk-path 2>/dev/null || true)"
if [ -z "$SDK_PATH" ]; then
  echo "iPhoneOS SDK not found; skipping Live Activity build."
  exit 0
fi

rm -rf "$DEST"
mkdir -p "$DEST"

echo "==> Compiling YTLiveActivity Widget Extension"
xcrun --sdk iphoneos swiftc \
  -target arm64-apple-ios17.0 \
  -emit-executable \
  -O \
  -framework WidgetKit \
  -framework SwiftUI \
  -framework ActivityKit \
  -framework Foundation \
  "$EXT_SRC/YTLiveActivityAttributes.swift" \
  "$EXT_SRC/YTLiveActivityWidget.swift" \
  -o "$DEST/YTLiveActivity"

cp "$EXT_SRC/Info.plist" "$DEST/Info.plist"

if command -v ldid >/dev/null 2>&1; then
  ldid -S "$DEST/YTLiveActivity"
fi

echo "==> Live Activity extension compiled at $DEST"
exit 0
