#!/bin/bash
# HarnessDA 제거 스크립트
# 심볼릭 링크만 제거한다. 원본 파일은 보존된다.

set -e

CLAUDE_ROOT="$HOME/.claude"

echo "=== HarnessDA Uninstall ==="
echo ""

removed=0

# 스킬 제거
skills=("eda" "data-clean" "stat-analysis" "da-viz")
for skill in "${skills[@]}"; do
    target="$CLAUDE_ROOT/skills/$skill"
    if [ -L "$target" ]; then
        rm "$target"
        echo "  Skill removed: $skill"
        ((removed++))
    elif [ -e "$target" ]; then
        echo "  Skipped: $skill (심볼릭 링크 아님)"
    fi
done

# 에이전트 제거
agents=("data-profiler.md" "stat-analyst.md")
for agent in "${agents[@]}"; do
    target="$CLAUDE_ROOT/agents/$agent"
    if [ -L "$target" ]; then
        rm "$target"
        echo "  Agent removed: $agent"
        ((removed++))
    elif [ -e "$target" ]; then
        echo "  Skipped: $agent (심볼릭 링크 아님)"
    fi
done

# 커맨드 제거
commands=("da.md")
for cmd in "${commands[@]}"; do
    target="$CLAUDE_ROOT/commands/$cmd"
    if [ -L "$target" ]; then
        rm "$target"
        echo "  Command removed: $cmd"
        ((removed++))
    elif [ -e "$target" ]; then
        echo "  Skipped: $cmd (심볼릭 링크 아님)"
    fi
done

echo ""
if [ "$removed" -gt 0 ]; then
    echo "=== Uninstall Complete: ${removed} items removed ==="
else
    echo "=== Nothing to remove ==="
fi
