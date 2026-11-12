#!/usr/bin/env bash
set -euo pipefail

for f in "$1" "$2"; do
  if [[ ! -s $f ]]; then
    echo "error: empty file: $f" >&2
    exit 1
  fi
done

# Compare the header lines, ignoring a Windows \r.
h1=$(head -n 1 "$1" | tr -d '\r')
h2=$(head -n 1 "$2" | tr -d '\r')
if [[ $h1 != "$h2" ]]; then
  echo "error: headers differ" >&2
  exit 1
fi

tab=$'\t'

# awk emits "key<TAB>line"; sort puts the lines in key order; cut drops the key.
diffs=$(
  awk -F, '
    { sub(/\r$/, "") }
    $0 == "" || FNR == 1 { next }               # blank lines and both headers

    {
      rest = substr($0, length($1) + 2)         # everything after the first comma
    }

    FNR == NR { old[$1] = rest; next }          # first file: remember (last one wins)

    { new[$1] = rest }                          # second file

    END {
      for (k in new)
        if (!(k in old))            print k "\t+ " k "," new[k]
        else if (old[k] != new[k])  print k "\t~ " k ": " old[k] " -> " new[k]
      for (k in old)
        if (!(k in new))            print k "\t- " k "," old[k]
    }
  ' "$1" "$2" | sort -t "$tab" -k1,1 | cut -f2-
)

if [[ -z $diffs ]]; then
  echo "no differences"
  exit 0
fi

printf '%s\n' "$diffs"

# grep -c prints 0 but exits 1 when nothing matches; "|| true" keeps set -e quiet.
added=$(printf '%s\n' "$diffs" | grep -c '^+ ' || true)
removed=$(printf '%s\n' "$diffs" | grep -c '^- ' || true)
changed=$(printf '%s\n' "$diffs" | grep -c '^~ ' || true)
echo "summary: $added added, $removed removed, $changed changed"
