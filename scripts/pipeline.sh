#!/usr/bin/env bash
# Builds the YTMVitrine tweak and injects it into a decrypted YouTube Music IPA.
#
#   scripts/pipeline.sh <decrypted.ipa> [-o out.ipa] [--no-flex]
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEOS="${THEOS:-$HOME/theos}"
BUNDLE_ID="${BUNDLE_ID:-}"
mkdir -p "$ROOT/out"

IN="" OUT="" WITH_FLEX=0
while [ $# -gt 0 ]; do
  case "$1" in
    -o) OUT="$2"; shift 2 ;;
    --no-flex) WITH_FLEX=0; shift ;;
    --flex) WITH_FLEX=1; shift ;;
    -h|--help) echo "Usage: pipeline.sh <input.ipa> [-o out.ipa]"; exit 0 ;;
    *) IN="$1"; shift ;;
  esac
done

[ -n "$IN" ] || { echo "no IPA: provide a decrypted YouTube Music .ipa file" >&2; exit 1; }
[ -f "$IN" ] || { echo "no such file: $IN" >&2; exit 1; }

need() { command -v "$1" >/dev/null 2>&1 || { echo "missing $1 -> $2" >&2; exit 1; }; }
need gmake "brew install make"
need ldid "brew install ldid"
need dpkg-deb "brew install dpkg"
need cyan "uv tool install 'cyan @ git+https://github.com/asdfzxcvbn/pyzule-rw'"

APP_DIR="$(unzip -Z1 "$IN" | grep -oE '^Payload/[^/]+\.app/' | sort -u | head -1)"
[ -n "$APP_DIR" ] || { echo "no Payload/*.app in $IN" >&2; exit 1; }

MOD_VERSION="$(cat "$ROOT/version.txt" 2>/dev/null || true)"
: "${MOD_VERSION:=1.0.0}"
OUT="${OUT:-$ROOT/out/ytm-vitrine-$MOD_VERSION.ipa}"
echo "==> Building YTMVitrine $MOD_VERSION for $IN -> $OUT"

echo "==> Compiling Theos tweak"
(cd "$ROOT/tweak" && gmake clean && gmake FINALPACKAGE=1)

DYLIB="$ROOT/tweak/.theos/obj/debug/YTMVitrine.dylib"
if [ ! -f "$DYLIB" ]; then
  DYLIB="$ROOT/tweak/.theos/obj/YTMVitrine.dylib"
fi
if [ ! -f "$DYLIB" ]; then
  DYLIB="$(find "$ROOT/tweak/.theos" -name "YTMVitrine.dylib" 2>/dev/null | head -1)"
fi

[ -f "$DYLIB" ] || { echo "Failed to find built YTMVitrine.dylib" >&2; exit 1; }

# Remove conflicting extensions and watch app so that personal certs install cleanly
echo "==> Injecting YTMVitrine.dylib into YouTube Music IPA"
cyan -i "$IN" -o "$OUT" -f "$DYLIB" -e -w -u --overwrite ${BUNDLE_ID:+-b "$BUNDLE_ID"}

echo "==> Successfully created installable IPA: $OUT"
exit 0
