#!/usr/bin/env bash
# Config drift detector: golden tree versus live tree, ignoring noise, hiding secrets.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--plan] GOLDEN_DIR LIVE_DIR" >&2
  exit 2
}

plan=0
if [[ ${1:-} == --plan ]]; then
  plan=1
  shift
fi
[[ $# -eq 2 ]] || usage
golden=${1%/}
live=${2%/}
for d in "$1" "$2"; do
  if [[ ! -d $d ]]; then
    echo "error: $d is not a directory" >&2
    exit 2
  fi
done

# Control files.
declare -A want_mode
if [[ -f $golden/.modes ]]; then
  while read -r p m _; do
    [[ -n $p ]] && want_mode[$p]=$m
  done < "$golden/.modes"
fi
ignored=
if [[ -f $golden/.ignore ]]; then
  ignored=$(tr '\n' ' ' < "$golden/.ignore")
fi

# mode_octal FILE: "-rw-r-----" -> 640 using only ls -l.
mode_octal() {
  local m i n out=
  m=$(ls -l "$1" | cut -c2-10)
  for i in 0 3 6; do
    n=0
    [[ ${m:i:1} == r ]] && n=$((n + 4))
    [[ ${m:i+1:1} == w ]] && n=$((n + 2))
    [[ ${m:i+2:1} == [xst] ]] && n=$((n + 1))
    out+=$n
  done
  echo "$out"
}

# conf_diff GOLDEN LIVE: indented difference lines, sorted by key.
conf_diff() {
  awk -v ignored="$ignored" '
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    function secret(k) { k = tolower(k); return k ~ /pass|secret|token|key/ }
    function show(k, v) { return secret(k) ? "***" : v }
    /^[ \t]*[#;]/ || !/=/ { next }
    {
      eq = index($0, "=")
      k = trim(substr($0, 1, eq - 1)); v = trim(substr($0, eq + 1))
      if (v ~ /^".*"$/) v = substr(v, 2, length(v) - 2)
      if (index(" " ignored " ", " " k " ")) next
      if (FNR == NR) { g[k] = v; keys[k] = 1 } else { l[k] = v; keys[k] = 1 }
    }
    END {
      for (k in keys) {
        if ((k in g) && (k in l)) { if (g[k] != l[k]) print k "|  ~ " k ": " show(k, g[k]) " -> " show(k, l[k]) }
        else if (k in l) print k "|  + " k ": " show(k, l[k])
        else print k "|  - " k ": " show(k, g[k])
      }
    }' "$1" "$2" | sort -t'|' -k1,1 | cut -d'|' -f2-
}

all=$(
  { (cd "$golden" && find . -type f ! -path ./.modes ! -path ./.ignore | sed 's|^\./||')
    (cd "$live" && find . -type f | sed 's|^\./||')
  } | sort -u
)

checked=0 drifted=0 missing=0 unmanaged=0
commands=()
while IFS= read -r rel; do
  [[ -n $rel ]] || continue
  in_golden=0
  [[ -f $golden/$rel && $rel != .modes && $rel != .ignore ]] && in_golden=1
  if (( ! in_golden )); then
    unmanaged=$((unmanaged + 1))
    if (( plan )); then commands+=("# unmanaged: $live/$rel (decide by hand)"); else echo "UNMANAGED $rel"; fi
    continue
  fi
  checked=$((checked + 1))
  if [[ ! -f $live/$rel ]]; then
    missing=$((missing + 1))
    if (( plan )); then
      [[ $rel != */* ]] || commands+=("mkdir -p '$live/${rel%/*}'")
      commands+=("cp '$golden/$rel' '$live/$rel'")
      [[ -z ${want_mode[$rel]:-} ]] || commands+=("chmod ${want_mode[$rel]} '$live/$rel'")
    else
      echo "MISSING $rel"
    fi
    continue
  fi

  detail=()
  content_bad=0
  if [[ $rel == *.conf ]]; then
    diffs=$(conf_diff "$golden/$rel" "$live/$rel")
    if [[ -n $diffs ]]; then
      content_bad=1
      while IFS= read -r line; do detail+=("$line"); done <<< "$diffs"
    fi
  elif [[ $(cksum < "$golden/$rel") != "$(cksum < "$live/$rel")" ]]; then
    content_bad=1
    detail+=("  ~ content differs")
  fi
  mode_bad=0
  if [[ -n ${want_mode[$rel]:-} ]]; then
    found=$(mode_octal "$live/$rel")
    if [[ $found != "${want_mode[$rel]}" ]]; then
      mode_bad=1
      detail+=("  ~ mode: expected ${want_mode[$rel]}, found $found")
    fi
  fi
  (( content_bad || mode_bad )) || continue
  drifted=$((drifted + 1))
  if (( plan )); then
    (( ! content_bad )) || commands+=("cp '$golden/$rel' '$live/$rel'")
    if [[ -n ${want_mode[$rel]:-} ]] && (( mode_bad || content_bad )); then
      commands+=("chmod ${want_mode[$rel]} '$live/$rel'")
    fi
  else
    echo "DRIFT $rel"
    printf '%s\n' "${detail[@]}"
  fi
done <<< "$all"

if (( plan )); then
  echo "# remediation plan (review before running)"
  (( ${#commands[@]} == 0 )) || printf '%s\n' "${commands[@]}"
else
  echo "files: $checked checked, $drifted drifted, $missing missing, $unmanaged unmanaged"
fi
(( drifted + missing + unmanaged == 0 )) || exit 1
