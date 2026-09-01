#!/usr/bin/env bash
# 在 Caju Flutter 应用仓库根目录执行。
# 用法：APP_SLUG=db-meter-caju package_github_assets.sh [android|ios|macos|windows|all]
set -euo pipefail

if [[ -z "${APP_SLUG:-}" ]]; then
  echo "Set APP_SLUG (portal slug), e.g. db-meter-caju" >&2
  exit 1
fi

if [[ ! -f pubspec.yaml ]]; then
  echo "Run from the Flutter app repo root." >&2
  exit 1
fi

ROOT="$(pwd)"
OUT="$ROOT/dist/github"
mkdir -p "$OUT"

targets=("${@:-all}")
if [[ ${#targets[@]} -eq 1 && "${targets[0]}" == "all" ]]; then
  targets=(android ios macos windows)
fi

has() {
  local x="$1"
  shift
  local t
  for t in "$@"; do
    [[ "$t" == "$x" ]] && return 0
  done
  return 1
}

package_android() {
  flutter build apk --release
  cp -f "$ROOT/build/app/outputs/flutter-apk/app-release.apk" "$OUT/${APP_SLUG}-android.apk"
}

package_macos() {
  flutter build macos --release
  local app vol stage
  app="$(find "$ROOT/build/macos/Build/Products/Release" -maxdepth 1 -name '*.app' | head -n 1)"
  if [[ -z "$app" ]]; then
    echo "No .app under build/macos/Build/Products/Release" >&2
    exit 1
  fi
  vol="${APP_DISPLAY_NAME:-$APP_SLUG}"
  stage="$(mktemp -d)"
  ditto "$app" "$stage/$(basename "$app")"
  ln -s /Applications "$stage/Applications"
  rm -f "$OUT/${APP_SLUG}-macos.dmg"
  hdiutil create -volname "$vol" -srcfolder "$stage" -ov -format UDZO \
    -imagekey zlib-level=9 "$OUT/${APP_SLUG}-macos.dmg"
  rm -rf "$stage"
}

package_ios() {
  flutter build ios --release --no-codesign
  local app payload
  app="$(find "$ROOT/build/ios/iphoneos" -maxdepth 1 -name '*.app' | head -n 1)"
  if [[ -z "$app" ]]; then
    echo "No .app under build/ios/iphoneos" >&2
    exit 1
  fi
  payload="$(mktemp -d)"
  mkdir -p "$payload/Payload"
  ditto "$app" "$payload/Payload/$(basename "$app")"
  rm -f "$OUT/${APP_SLUG}-ios.ipa"
  (cd "$payload" && zip -qry "$OUT/${APP_SLUG}-ios.ipa" Payload)
  rm -rf "$payload"
}

package_windows() {
  echo "Windows installer EXE is built on GitHub Actions (windows-latest + Inno Setup)." >&2
  echo "Do not package Windows on macOS." >&2
  exit 1
}

for t in "${targets[@]}"; do
  case "$t" in
    android) package_android ;;
    macos) package_macos ;;
    ios) package_ios ;;
    windows) package_windows ;;
    *) echo "Unknown target: $t" >&2; exit 1 ;;
  esac
done

ls -lh "$OUT/${APP_SLUG}"-* 2>/dev/null || ls -lh "$OUT"
