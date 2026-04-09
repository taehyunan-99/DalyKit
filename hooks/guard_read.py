#!/usr/bin/env python3
"""
DalyKit Read Guard (PreToolUse Hook)
Read 도구가 1000행 이상 파일을 직접 읽으려 할 때 차단한다. (Heavy-Task-Offload 강제)
"""

import json
import sys
from pathlib import Path

ROW_LIMIT = 1000


def count_lines(file_path: str) -> int:
    """파일 행 수 반환. 읽기 실패 시 0 반환."""
    try:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            return sum(1 for _ in f)
    except Exception:
        return 0


ALLOWED_PATHS = [
    "dalykit/code/results/",
]

ALLOWED_FILENAMES = [
    "eda_results.json",
    "clean_results.json",
    "feature_results.json",
    "model_results.json",
]


def is_allowed_path(file_path: str) -> bool:
    """허용된 경로 여부 확인 (결과 파일 등 직접 읽기 허용)"""
    p = Path(file_path).as_posix()
    if any(allowed in p for allowed in ALLOWED_PATHS):
        return True
    return Path(file_path).name in ALLOWED_FILENAMES


def is_data_file(file_path: str) -> bool:
    """데이터 파일 여부 확인 (CSV, TSV, JSON, Excel 등)"""
    data_extensions = {".csv", ".tsv", ".json", ".jsonl", ".parquet", ".xlsx", ".xls"}
    return Path(file_path).suffix.lower() in data_extensions


def main():
    try:
        raw = sys.stdin.read()
        hook_input = json.loads(raw)
    except Exception:
        sys.exit(0)

    tool_name = hook_input.get("tool_name", "")
    if tool_name != "Read":
        sys.exit(0)

    tool_input = hook_input.get("tool_input", {})
    file_path = tool_input.get("file_path", "")

    if not file_path:
        sys.exit(0)

    # 허용된 경로면 스킵
    if is_allowed_path(file_path):
        sys.exit(0)

    # 데이터 파일이 아니면 스킵
    if not is_data_file(file_path):
        sys.exit(0)

    # 파일이 존재하지 않으면 스킵 (Read가 알아서 에러 처리)
    if not Path(file_path).exists():
        sys.exit(0)

    # limit 파라미터가 명시된 경우 부분 읽기 → 허용
    limit = tool_input.get("limit")
    if limit is not None:
        sys.exit(0)

    line_count = count_lines(file_path)

    if line_count > ROW_LIMIT:
        response = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": (
                    f"[DalyKit Guard] 대용량 파일 직접 읽기 차단: '{Path(file_path).name}' ({line_count:,}행)\n"
                    f"1,000행 초과 데이터는 직접 읽지 말고 .py 스크립트로 처리해야 합니다. (Heavy-Task-Offload 규칙)\n"
                    f"대신 다음을 사용하세요:\n"
                    f"  - dalykit/code/ 에 분석 스크립트를 작성하고 Bash로 실행\n"
                    f"  - 결과 요약(JSON/MD)만 Read로 읽어 컨텍스트에 로드"
                ),
            }
        }
        print(json.dumps(response, ensure_ascii=False))

    sys.exit(0)


if __name__ == "__main__":
    main()
