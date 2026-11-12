#!/usr/bin/env bash
# A small test harness: discover, isolate, assert, report.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--filter TEXT] [--fail-fast] [--verbose] PATH..." >&2
  exit 2
}

filter=
fail_fast=0
verbose=0
while (( $# > 0 )); do
  case $1 in
    --filter)
      [[ -n ${2:-} ]] || usage
      filter=$2
      shift 2
      ;;
    --fail-fast) fail_fast=1; shift ;;
    --verbose) verbose=1; shift ;;
    -*) usage ;;
    *) break ;;
  esac
done
(( $# > 0 )) || usage

files=()
for p in "$@"; do
  if [[ -d $p ]]; then
    for f in "${p%/}"/*.test.sh; do
      [[ -f $f ]] && files+=("$f")
    done
  elif [[ -r $p ]]; then
    files+=("$p")
  else
    echo "error: cannot read $p" >&2
    exit 2
  fi
done

# Every file is scanned first so "no tests found" is known before anything runs.
declare -A names_of
found=0
for f in "${files[@]}"; do
  names_of[$f]=$(sed -n -E -e 's/^function +(test_[A-Za-z0-9_]+).*/\1/p' -e 's/^(test_[A-Za-z0-9_]+) *\(\).*/\1/p' "$f")
  found=$((found + $(printf '%s' "${names_of[$f]}" | grep -c . || true)))
done
if (( found == 0 )); then
  echo "error: no tests found" >&2
  exit 2
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
msg_file=$work/msg

# --- the API tests can call -----------------------------------------------------
fail() { printf '%s\n' "$*" > "$msg_file"; exit 1; }
skip() { printf '%s\n' "$*" > "$msg_file"; exit 77; }
assert_eq() { [[ $1 == "$2" ]] || fail "expected '$1' but got '$2'"; }
assert_contains() { [[ $1 == *"$2"* ]] || fail "'$1' does not contain '$2'"; }
assert_success() {
  local st=0
  "$@" > /dev/null 2>&1 || st=$?
  (( st == 0 )) || fail "command failed (status $st): $*"
}
assert_status() {
  local want=$1 st=0
  shift
  "$@" > /dev/null 2>&1 || st=$?
  [[ $st == "$want" ]] || fail "expected status $want but got $st from: $*"
}

total=0 passed=0 failed=0 skipped=0 file_errors=0 stop=0

# run_test FILE NAME: sets $outcome (PASS/FAIL/SKIP) and $detail.
run_test() {
  local file=$1 name=$2 dir tmp status
  dir=$(cd "$(dirname "$file")" && pwd)
  tmp=$(mktemp -d "$work/t.XXXXXX")
  : > "$msg_file"
  # errexit must be off *around* the subshell, not inside a || list,
  # otherwise `set -e` is ignored for everything the test does.
  set +e
  (
    set -e
    cd "$tmp"
    export TEST_DIR=$dir
    # shellcheck disable=SC1090
    source "$dir/${file##*/}"
    if declare -F teardown > /dev/null; then trap teardown EXIT; fi
    if declare -F setup > /dev/null; then setup; fi
    "$name"
  ) > "$work/out.txt" 2>&1
  status=$?
  set -e
  rm -rf "$tmp"
  detail=$(head -n 1 "$msg_file")
  case $status in
    0) outcome=PASS ;;
    77) outcome=SKIP ;;
    *)
      outcome=FAIL
      [[ -n $detail ]] || detail="exited with status $status"
      ;;
  esac
}

for f in "${files[@]}"; do
  (( ! stop )) || break
  echo "$f"
  if ! bash -n "$f" 2> /dev/null; then
    echo "  ERROR syntax error"
    file_errors=$((file_errors + 1))
    continue
  fi
  while IFS= read -r name; do
    [[ -n $name ]] || continue
    [[ -z $filter || $name == *"$filter"* ]] || continue
    total=$((total + 1))
    run_test "$f" "$name"
    case $outcome in
      PASS)
        passed=$((passed + 1))
        echo "  PASS $name"
        ;;
      SKIP)
        skipped=$((skipped + 1))
        echo "  SKIP $name ($detail)"
        ;;
      FAIL)
        failed=$((failed + 1))
        echo "  FAIL $name: $detail"
        if (( verbose )); then
          while IFS= read -r line; do echo "    | $line"; done < "$work/out.txt"
        fi
        if (( fail_fast )); then stop=1; break; fi
        ;;
    esac
  done <<< "${names_of[$f]}"
done

echo "summary: $total tests, $passed passed, $failed failed, $skipped skipped"
(( file_errors == 0 )) || echo "file errors: $file_errors"
if (( failed > 0 || file_errors > 0 )); then exit 1; fi
