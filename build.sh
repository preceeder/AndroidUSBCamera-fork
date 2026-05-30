#!/usr/bin/env bash
# Build release AARs and copy to ./build/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

echo "==> Building AARs..."
./gradlew \
  :libuvc:clean :libuvc:assembleRelease \
  :libausbc:assembleRelease \
  :libnative:assembleRelease

OUT_DIR="$ROOT/build"
mkdir -p "$OUT_DIR"

copy_aar() {
  local module="$1"
  local src="$ROOT/$module/build/outputs/aar/${module}-release.aar"
  local dst="$OUT_DIR/${module}-release.aar"
  if [[ ! -f "$src" ]]; then
    echo "ERROR: AAR not found: $src" >&2
    exit 1
  fi
  cp "$src" "$dst"
  echo "  copied: $dst ($(du -h "$dst" | cut -f1))"
}

echo "==> Copying to $OUT_DIR ..."
copy_aar libuvc
copy_aar libausbc
copy_aar libnative


echo ""
echo "Done. AAR files:"
ls -lh "$OUT_DIR"/*.aar

