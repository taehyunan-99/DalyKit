#!/bin/bash
# DalyKit local development sync script
# Marketplace 사용자는 이 스크립트가 아니라 /plugin marketplace install 흐름을 사용한다.
# 이 스크립트는 로컬 개발용으로 플러그인 번들을 ~/.claude/plugins/dev/dalykit 에 동기화한다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
TARGET_ROOT="$HOME/.claude/plugins/dev/dalykit"

echo "=== DalyKit Local Dev Sync ==="
echo "Source: $PLUGIN_ROOT"
echo "Target: $TARGET_ROOT"
echo ""

rm -rf "$TARGET_ROOT"
mkdir -p "$TARGET_ROOT"

for path in .claude-plugin shared skills templates README.md README.en.md; do
    if [ -e "$PLUGIN_ROOT/$path" ]; then
        cp -R "$PLUGIN_ROOT/$path" "$TARGET_ROOT/$path"
        echo "  Synced: $path"
    fi
done

echo ""
echo "=== Sync Complete ==="
echo "Local plugin bundle: $TARGET_ROOT"
echo ""
echo "Run for local testing:"
echo "  claude --plugin-dir \"$TARGET_ROOT\""
