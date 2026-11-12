#!/usr/bin/env bash
set -euo pipefail

cr=$'\r'

{
  # Take the header off the file ourselves. Because this read and the awk
  # below share one open file, awk starts exactly at line 2.
  header=
  if ! IFS= read -r header && [[ -z $header ]]; then
    exit 0                                   # empty file: nothing to print
  fi
  printf '%s\n' "${header%"$cr"}"

  awk -F, -v offset=1 '
    { sub(/\r$/, "") }
    $0 == "" { next }

    $1 == "" || $2 !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]Z$/ {
      printf "skipped line %d\n", NR + offset > "/dev/stderr"
      next
    }

    {
      key = tolower($1)
      # ISO timestamps compare correctly as text; >= lets a later line win a tie.
      if (!(key in stamp) || $2 >= stamp[key]) {
        stamp[key] = $2
        rest = substr($0, length($1) + 2)    # everything after the email
        row[key] = key "," rest
      }
    }

    END { for (k in row) print row[k] }
  ' | sort -t, -k1,1
} < "$1"
