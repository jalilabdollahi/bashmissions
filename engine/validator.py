"""Validation helpers for BashMissions."""
from __future__ import annotations

import re


def normalize_whitespace(text: str) -> str:
    return " ".join(text.split())


def compare_output(actual: str, expected: str, mode: str) -> bool:
    if mode == "exact":
        return actual == expected
    if mode == "contains":
        return expected in actual
    if mode == "ignore_whitespace":
        return normalize_whitespace(actual) == normalize_whitespace(expected)
    if mode == "regex":
        return re.fullmatch(expected, actual) is not None
    raise ValueError(f"Unknown comparison mode: {mode}")


def validate_all(results: list[dict]) -> dict:
    passed = all(item.get("passed") for item in results)
    summary = f"{sum(1 for item in results if item.get('passed'))}/{len(results)} tests passed"
    return {"passed": passed, "results": results, "summary": summary}
