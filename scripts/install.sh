#!/bin/bash
# DalyKit 설치 스크립트
# 파일을 ~/.claude/에 복사하여 설치한다

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HARNESS_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_ROOT="$HOME/.claude"

echo "=== DalyKit Install ==="
echo "Source: $HARNESS_ROOT"
echo "Target: $CLAUDE_ROOT"
echo ""

# 대상 디렉토리 생성
for dir in skills shared hooks; do
    target_dir="$CLAUDE_ROOT/$dir"
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        echo "  Created dir: $target_dir"
    fi
done

# 스킬 설치 (디렉토리 복사)
skills=("init" "domain" "eda" "clean" "stat" "feature" "model" "help")
for skill in "${skills[@]}"; do
    source="$HARNESS_ROOT/skills/$skill"
    target="$CLAUDE_ROOT/skills/$skill"

    rm -rf "$target"
    cp -r "$source" "$target"
    echo "  Skill installed: $skill"
done

# viz 공유 참조 문서 설치 (스킬이 아닌 공유 참조 문서)
rm -rf "$CLAUDE_ROOT/shared/viz"
cp -r "$HARNESS_ROOT/shared/viz" "$CLAUDE_ROOT/shared/viz"
echo "  Shared docs installed: viz"

# 템플릿 설치
mkdir -p "$CLAUDE_ROOT/templates"
cp -r "$HARNESS_ROOT/templates/"* "$CLAUDE_ROOT/templates/"
echo "  Templates installed"

# guard_write 글로벌 설치 (guard_read는 프로젝트별 래퍼로 설치 — dalykit:init 참조)
cp "$HARNESS_ROOT/hooks/guard_write.py" "$CLAUDE_ROOT/hooks/guard_write.py"
echo "  Hooks installed"

echo ""
echo "=== Install Complete ==="
echo "Skills: ${#skills[@]}, Shared: viz, templates, hooks"
echo ""
echo "Usage: type 'dalykit:help' in Claude Code"
