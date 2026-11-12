#!/usr/bin/env bash
# Disk cleanup driven by a policy file: each rule is "PATTERN DAYS BYTES".
# Validate the policy, then apply the rules in order; -n only reports.

# TODO: optional -n, then POLICY and DIR (usage, readability, directory checks)
# TODO: first pass over the policy: every rule must be 3 fields, 2 numbers; else exit 1
# TODO: second pass: build the find command for each rule (-name, then -mtime / -size when > 0)
# TODO: sort the matches, skip files an earlier rule already removed
# TODO: measure each file's size before deleting; print delete / would delete lines
# TODO: the summary line depends on dry-run mode
