#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi
if ! grep -q '^\*filter' "$file"; then
  echo "not an iptables-save export: $file" >&2
  exit 1
fi

# One awk pass. NR is the line number, and the END block sets the exit status.
awk '
  /^:INPUT / {
    if ($2 == "ACCEPT") { printf "line %d: INPUT policy is ACCEPT\n", NR; found++ }
  }
  /^-A / { rules++ }
  /^-A INPUT / {
    src = ""; iface = ""; proto = ""; mod = 0; ports = ""; target = ""
    for (i = 2; i <= NF; i++) {
      if      ($i == "-s")                       src    = $(i + 1)
      else if ($i == "-i")                       iface  = $(i + 1)
      else if ($i == "-p")                       proto  = $(i + 1)
      else if ($i == "-m")                       mod    = 1
      else if ($i == "--dport" || $i == "--dports") ports = $(i + 1)
      else if ($i == "-j")                       target = $(i + 1)
    }
    world = (src == "" || src == "0.0.0.0/0")
    if (target == "ACCEPT" && world) {
      if (ports != "") {
        n = split(ports, p, ",")
        for (k = 1; k <= n; k++) {
          if (index(p[k], ":") > 0) {
            printf "line %d: port range %s open to the world\n", NR, p[k]; found++
          } else if (p[k] == 22 || p[k] == 3306 || p[k] == 5432 || p[k] == 6379) {
            printf "line %d: port %s open to the world\n", NR, p[k]; found++
          }
        }
      } else if (iface == "" && proto == "" && !mod) {
        printf "line %d: accepts all traffic\n", NR; found++
      }
    }
  }
  END {
    printf "audited %d rules, %d findings\n", rules, found
    exit (found > 0)
  }
' "$file"
