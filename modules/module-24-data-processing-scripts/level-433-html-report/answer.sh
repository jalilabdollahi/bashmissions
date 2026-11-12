#!/usr/bin/env bash
set -euo pipefail

# Bash 5.2 lets & in the replacement of ${var//pat/repl} mean "the matched
# text" (like sed). We want a plain ampersand, so switch that feature off.
# Older bashes do not know the option; the || true keeps them happy.
shopt -u patsub_replacement 2>/dev/null || true

escaped=
html_escape() {
  local s=$1
  s=${s//&/&amp;}          # & FIRST, or the & in &lt; would be escaped again
  s=${s//</&lt;}
  s=${s//>/&gt;}
  escaped=$s
}

cr=$'\r'
rows=
count=0

{
  read -r _header || true
  while IFS=, read -r time server summary || [[ -n $time ]]; do
    time=${time%"$cr"}; summary=${summary%"$cr"}   # the \r lands in the last variable, or in the first on a blank line
    [[ -z $time ]] && continue
    html_escape "$time";    t=$escaped
    html_escape "$server";  s=$escaped
    html_escape "$summary"; m=$escaped
    rows+="<tr><td>$t</td><td>$s</td><td>$m</td></tr>"$'\n'
    count=$((count + 1))
  done
} < "$1"

# The template: $count and $rows are filled in by the shell. Data inside the
# variables is NOT expanded a second time, so a summary containing $(...) is safe.
cat <<EOF
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Incident report</title></head>
<body>
<h1>Incident report</h1>
<table>
<tr><th>Time</th><th>Server</th><th>Summary</th></tr>
${rows}</table>
<p>$count incident(s)</p>
</body>
</html>
EOF
