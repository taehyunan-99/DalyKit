#!/bin/bash
# HarnessDA 제거 스크립트
# 설치된 파일을 제거한다. 원본 파일은 보존된다.

set -e

CLAUDE_ROOT="$HOME/.claude"

echo "=== HarnessDA Uninstall ==="
echo ""

removed=0

# 스킬 제거
skills=("init" "eda" "clean" "stat" "report" "help")
for skill in "${skills[@]}"; do
    target="$CLAUDE_ROOT/skills/$skill"
    if [ -d "$target" ]; then
        rm -rf "$target"
        echo "  Skill removed: $skill"
        ((removed++))
    fi
done

# viz 공유 참조 문서 제거
if [ -d "$CLAUDE_ROOT/skills/viz" ]; then
    rm -rf "$CLAUDE_ROOT/skills/viz"
    echo "  Shared docs removed: viz"
    ((removed++))
fi

# 템플릿 제거
if [ -d "$CLAUDE_ROOT/templates" ]; then
    rm -rf "$CLAUDE_ROOT/templates"
    echo "  Templates removed"
    ((removed++))
fi

# 에이전트 제거
agents=("data-profiler.md")
for agent in "${agents[@]}"; do
    target="$CLAUDE_ROOT/agents/$agent"
    if [ -f "$target" ]; then
        rm -f "$target"
        echo "  Agent removed: $agent"
        ((removed++))
    fi
done

echo ""
if [ "$removed" -gt 0 ]; then
    echo "=== Uninstall Complete: ${removed} items removed ==="
else
    echo "=== Nothing to remove ==="
fi
