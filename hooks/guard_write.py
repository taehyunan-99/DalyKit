#!/usr/bin/env python3
"""
DalyKit Write Guard (PreToolUse Hook)
Write/Edit 도구가 dalykit/ 외부에 파일을 생성/수정하려 할 때 차단한다.
"""

import json
import sys
from pathlib import Path


def get_allowed_roots(cwd: str) -> list:
    """쓰기 허용 경로 목록 반환"""
    project = Path(cwd).resolve()
    return [
        project / "dalykit",
    ]


def is_allowed(file_path: str, cwd: str) -> bool:
    """파일 경로가 dalykit/ 하위인지 확인"""
    try:
        target = Path(file_path).resolve()
        for root in get_allowed_roots(cwd):
            try:
                target.relative_to(root)
                return True
            except ValueError:
                continue
        return False
    except Exception:
        # 경로 파싱 실패 시 허용 (오탐 방지)
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
                    f"분석 결과물은 반드시 dalykit/ 하위에 저장해야 합니다.\n"
                    f"올바른 경로: dalykit/data/, dalykit/code/, dalykit/docs/, dalykit/figures/"
                ),
            }
        }
        print(json.dumps(response, ensure_ascii=False))

    sys.exit(0)


if __name__ == "__main__":
    main()
