#!/usr/bin/env bash
set -euo pipefail

awk -F, '
  # Escape one character at a time. gsub with backslashes in the replacement
  # means different things in different awks; a loop means the same everywhere.
  function esc(s,    out, i, c) {
    out = ""
    for (i = 1; i <= length(s); i++) {
      c = substr(s, i, 1)
      if (c == "\\")      out = out "\\\\"
      else if (c == "\"") out = out "\\\""
      else                out = out c
    }
    return out
  }

  function val(s) {
    if (s == "") return "null"
    if (s ~ /^-?(0|[1-9][0-9]*)(\.[0-9]+)?$/) return s
    return "\"" esc(s) "\""
  }

  { sub(/\r$/, "") }
  $0 == "" { next }

  NR == 1 {
    for (i = 1; i <= NF; i++) key[i] = $i
    nkeys = NF
    next
  }

  {
    obj = "  {"
    for (i = 1; i <= nkeys; i++)
      obj = obj (i > 1 ? "," : "") "\"" esc(key[i]) "\":" val($i)
    obj = obj "}"

    # print the previous object with a comma now that we know another follows
    if (count == 0) print "["
    else print prev ","
    prev = obj
    count++
  }

  END {
    if (count == 0) print "[]"
    else { print prev; print "]" }
  }
' "$1"
