#!/bin/bash
# DalyKit local development uninstall script
# ~/.claude/plugins/dev/dalykit 개발용 번들만 제거한다.

set -euo pipefail

TARGET_ROOT="$HOME/.claude/plugins/dev/dalykit"

echo "=== DalyKit Local Dev Uninstall ==="
echo "Target: $TARGET_ROOT"
echo ""

if [ -d "$TARGET_ROOT" ]; then
    rm -rf "$TARGET_ROOT"
    echo "Removed: $TARGET_ROOT"
    echo ""
    echo "=== Uninstall Complete ==="
else
    echo "Nothing to remove."
fi
