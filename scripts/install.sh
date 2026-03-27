#!/bin/bash
# HarnessDA 설치 스크립트
# 심볼릭 링크로 HarnessDA를 ~/.claude/에 연결한다

set -e

# 스크립트 위치 기준으로 프로젝트 루트 결정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HARNESS_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_ROOT="$HOME/.claude"

echo "=== HarnessDA Install ==="
echo "Source: $HARNESS_ROOT"
echo "Target: $CLAUDE_ROOT"
echo ""

# 대상 디렉토리 생성
for dir in skills agents commands; do
    target_dir="$CLAUDE_ROOT/$dir"
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        echo "  Created dir: $target_dir"
    fi
done

installed=0

# 스킬 설치 (디렉토리 심볼릭 링크)
skills=("eda" "data-clean" "stat-analysis" "da-viz")
for skill in "${skills[@]}"; do
    source="$HARNESS_ROOT/skills/$skill"
    target="$CLAUDE_ROOT/skills/$skill"

    if [ -e "$target" ]; then
        if [ -L "$target" ]; then
            rm "$target"
        else
            echo "  WARN: $target 이미 존재 (심볼릭 링크 아님). 건너뜀."
            continue
        fi
    fi

    ln -s "$source" "$target"
    echo "  Skill installed: $skill"
    ((installed++))
done

# 에이전트 설치 (파일 심볼릭 링크)
agents=("data-profiler.md" "stat-analyst.md")
for agent in "${agents[@]}"; do
    source="$HARNESS_ROOT/agents/$agent"
    target="$CLAUDE_ROOT/agents/$agent"

    if [ -e "$target" ]; then
        if [ -L "$target" ]; then
            rm "$target"
        else
            echo "  WARN: $target 이미 존재 (심볼릭 링크 아님). 건너뜀."
            continue
        fi
    fi

    ln -s "$source" "$target"
    echo "  Agent installed: $agent"
    ((installed++))
done

# 커맨드 설치 (파일 심볼릭 링크)
commands=("da.md")
for cmd in "${commands[@]}"; do
    source="$HARNESS_ROOT/commands/$cmd"
    target="$CLAUDE_ROOT/commands/$cmd"

    if [ -e "$target" ]; then
        if [ -L "$target" ]; then
            rm "$target"
        else
            echo "  WARN: $target 이미 존재 (심볼릭 링크 아님). 건너뜀."
            continue
        fi
    fi

    ln -s "$source" "$target"
    echo "  Command installed: $cmd"
    ((installed++))
done

echo ""
echo "=== Install Complete: ${installed} items installed ==="
echo "Skills: ${#skills[@]}, Agents: ${#agents[@]}, Commands: ${#commands[@]}"
echo ""
echo "Usage: type '/da' in Claude Code"
