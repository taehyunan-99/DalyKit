#!/bin/bash
# HarnessDA 설치 스크립트
# 파일을 ~/.claude/에 복사하여 설치한다

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HARNESS_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_ROOT="$HOME/.claude"

echo "=== HarnessDA Install ==="
echo "Source: $HARNESS_ROOT"
echo "Target: $CLAUDE_ROOT"
echo ""

# 대상 디렉토리 생성
for dir in skills agents; do
    target_dir="$CLAUDE_ROOT/$dir"
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        echo "  Created dir: $target_dir"
    fi
done

# 스킬 설치 (디렉토리 복사)
skills=("eda" "data-clean" "stat-analysis" "viz" "report" "help" "tracker")
for skill in "${skills[@]}"; do
    source="$HARNESS_ROOT/skills/$skill"
    target="$CLAUDE_ROOT/skills/$skill"

    rm -rf "$target"
    cp -r "$source" "$target"
    echo "  Skill installed: $skill"
done

# 에이전트 설치 (파일 복사)
agents=("data-profiler.md")
for agent in "${agents[@]}"; do
    source="$HARNESS_ROOT/agents/$agent"
    target="$CLAUDE_ROOT/agents/$agent"

    cp "$source" "$target"
    echo "  Agent installed: $agent"
done

echo ""
echo "=== Install Complete ==="
echo "Skills: ${#skills[@]}, Agents: ${#agents[@]}"
echo ""
echo "Usage: type 'harnessda:help' in Claude Code"
