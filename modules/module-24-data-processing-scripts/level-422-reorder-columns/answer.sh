#!/usr/bin/env bash
set -euo pipefail

# The header row is the lookup table: pos["email"] = 3, and so on. Every line,
# header included, is then rebuilt from the wanted names.
awk -F, -v OFS=, -v wanted="$2" '
  { sub(/\r$/, "") }
  NR == 1 {
    for (i = 1; i <= NF; i++) pos[$i] = i
    n = split(wanted, want, ",")
    for (j = 1; j <= n; j++)
      if (!(want[j] in pos)) {
        print "unknown column: " want[j] > "/dev/stderr"   # portable-ok
        exit 1                    # nothing has been printed yet
      }
  }
  {
    out = ""
    for (j = 1; j <= n; j++)
      out = out (j > 1 ? OFS : "") $(pos[want[j]])
    print out
  }
' "$1"
