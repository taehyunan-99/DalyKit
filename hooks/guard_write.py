#!/usr/bin/env python3
"""
DalyKit Write Guard (PreToolUse Hook)
Write/Edit 도구가 프로젝트 폴더(cwd) 외부에 파일을 생성/수정하려 할 때 차단한다.
"""

import json
import sys
from pathlib import Path


# 프로젝트 외부에 저장하면 안 되는 분석 산출물 확장자
BLOCKED_EXTENSIONS_OUTSIDE_PROJECT = {
    ".csv", ".parquet", ".pkl", ".joblib",
    ".ipynb", ".png", ".jpg", ".jpeg", ".svg",
    ".json",
}


def is_analysis_artifact(file_path: str) -> bool:
    """분석 산출물 파일 여부 확인"""
    return Path(file_path).suffix.lower() in BLOCKED_EXTENSIONS_OUTSIDE_PROJECT


def is_inside_project(file_path: str, cwd: str) -> bool:
    """파일 경로가 프로젝트(cwd) 하위인지 확인"""
    target = Path(file_path).resolve()
    project_root = Path(cwd).resolve()
    try:
        target.relative_to(project_root)
        return True
    except ValueError:
        return False


def is_allowed(file_path: str, cwd: str) -> bool:
    """분석 산출물이 프로젝트 외부에 저장되는 경우만 차단"""
    try:
        if not is_analysis_artifact(file_path):
            return True
        return is_inside_project(file_path, cwd)
    except Exception:
        return True


def main():
    try:
        raw = sys.stdin.read()
        hook_input = json.loads(raw)
    except Exception:
        sys.exit(0)

    tool_name = hook_input.get("tool_name", "")
    if tool_name not in ("Write", "Edit"):
        sys.exit(0)

    tool_input = hook_input.get("tool_input", {})
    file_path = tool_input.get("file_path", "")
    cwd = hook_input.get("cwd", "")

    if not file_path or not cwd:
        sys.exit(0)

    if not is_allowed(file_path, cwd):
        response = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": (
                    f"[DalyKit Guard] 쓰기 차단: '{file_path}'\n"
                    f"분석 결과물은 프로젝트 폴더 내에 저장해야 합니다.\n"
                    f"올바른 경로: dalykit/data/, dalykit/code/, dalykit/docs/, dalykit/figures/"
                ),
            }
        }
        print(json.dumps(response, ensure_ascii=False))

    sys.exit(0)


if __name__ == "__main__":
    main()
