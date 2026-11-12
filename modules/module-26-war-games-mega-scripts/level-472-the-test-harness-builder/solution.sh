#!/usr/bin/env bash
# A tiny test harness for shell functions: discover test_* functions, run each in
# an isolated subshell with its own directory, provide assertions, report.
#   solution.sh [--filter TEXT] [--fail-fast] [--verbose] PATH...

# TODO: parse the options; expand directories into *.test.sh files; exit 2 on bad paths
# TODO: discover test names by reading each file (sed -n -E), in order of appearance; "no tests found"
# TODO: the assertion API: fail, skip (status 77), assert_eq, assert_contains, assert_success, assert_status;
#       messages travel through a file
# TODO: run_test: fresh mktemp -d directory, TEST_DIR, a subshell with set -e that sources the file,
#       runs setup, the test, and teardown via trap EXIT; capture output; errexit off around the subshell
# TODO: map the exit status to PASS / SKIP / FAIL and the message
# TODO: bash -n each file first; print the report, --verbose output, --fail-fast, the summary and exit status
