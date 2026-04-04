#!/bin/bash
# DalyKit 제거 스크립트
# 설치된 파일을 제거한다. 원본 파일은 보존된다.

set -e

CLAUDE_ROOT="$HOME/.claude"

echo "=== DalyKit Uninstall ==="
echo ""

removed=0

# 스킬 제거
skills=("init" "domain" "eda" "clean" "stat" "help")
for skill in "${skills[@]}"; do
    target="$CLAUDE_ROOT/skills/$skill"
    if [ -d "$target" ]; then
        rm -rf "$target"
        echo "  Skill removed: $skill"
        ((removed++))
    fi
done

# viz 공유 참조 문서 제거
if [ -d "$CLAUDE_ROOT/shared/viz" ]; then
    rm -rf "$CLAUDE_ROOT/shared/viz"
    echo "  Shared docs removed: viz"
    ((removed++))
fi

# 템플릿 제거
if [ -d "$CLAUDE_ROOT/templates" ]; then
    rm -rf "$CLAUDE_ROOT/templates"
    echo "  Templates removed"
    ((removed++))
fi

# hook 스크립트 제거
for hook in "guard_write.py" "guard_read.py"; do
    target="$CLAUDE_ROOT/hooks/$hook"
    if [ -f "$target" ]; then
        rm -f "$target"
        echo "  Hook removed: $hook"
        ((removed++))
    fi
done

echo ""
if [ "$removed" -gt 0 ]; then
    echo "=== Uninstall Complete: ${removed} items removed ==="
else
    echo "=== Nothing to remove ==="
fi
