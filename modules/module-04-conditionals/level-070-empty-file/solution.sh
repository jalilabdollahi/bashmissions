#!/usr/bin/env bash
# Checkpoint before the report is mailed: $1 is the report file.
# Not empty -> "ok: <file>, lines: <n>". Empty or missing -> error on stderr, exit 1.

# TODO: one test covers both "missing" and "zero bytes" (look at -s)
# TODO: success path: count the lines with wc -l < "$file" inside $(( ))
