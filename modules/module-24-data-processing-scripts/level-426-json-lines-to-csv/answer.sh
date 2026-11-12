#!/usr/bin/env bash
set -euo pipefail

awk '
  # Return the value of "key" in line, or "" if the key is absent.
  function get(line, key,    pat, p, rest, out, i, c, n) {
    pat = "\"" key "\":"
    p = index(line, pat)
    if (p == 0) return ""
    rest = substr(line, p + length(pat))
    sub(/^ +/, "", rest)

    if (substr(rest, 1, 1) == "\"") {          # a string: read to the closing quote
      out = ""
      n = length(rest)
      for (i = 2; i <= n; i++) {
        c = substr(rest, i, 1)
        if (c == "\\") { out = out substr(rest, i + 1, 1); i++ }   # \" -> "  \\ -> \
        else if (c == "\"") break
        else out = out c
      }
      return out
    }
    match(rest, /^[^,} ]*/)                    # a bare number / true / false / null
    c = substr(rest, 1, RLENGTH)
    return (c == "null") ? "" : c
  }

  # CSV rule: quote a cell that contains a comma or a quote, double the quotes.
  function csv(v) {
    if (v ~ /[,"]/) {
      gsub(/"/, "\"\"", v)
      v = "\"" v "\""
    }
    return v
  }

  BEGIN { print "ts,host,status,msg" }
  { sub(/\r$/, "") }
  $0 == "" { next }
  {
    print csv(get($0, "ts")) "," csv(get($0, "host")) "," csv(get($0, "status")) "," csv(get($0, "msg"))
  }
' "$1"
