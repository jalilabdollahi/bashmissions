#!/usr/bin/env bash
set -euo pipefail

# State is three numbers (running, rows, line count). Nothing grows with the
# size of the input, so this can run on a stream that never ends, and output
# appears as soon as each line arrives. No temporary file is needed: the pipe
# between processes is the only buffer.
awk -F, '
  # cents -> "-12.34": sign, whole dollars, two digits of cents (integers only)
  function dollars(c,    sign) {
    sign = ""
    if (c < 0) { sign = "-"; c = -c }
    return sprintf("%s%.0f.%02d", sign, int(c / 100), c % 100)
  }

  { sub(/\r$/, "") }

  NR == 1 { print "ts,amount,running"; next }
  $0 == "" { next }

  $1 == "" || $2 !~ /^-?[0-9]+$/ || NF != 2 {
    printf "bad line %d: %s\n", NR, $0 > "/dev/stderr"
    next
  }

  {
    running += $2
    rows++
    print $1 "," dollars($2) "," dollars(running)
  }

  END {
    if (NR > 0) printf "# rows=%d total=%s\n", rows, dollars(running + 0)
  }
'
