# Common Mistakes

- **Sorting without the tie-breakers.** Wrong: `sort -t'|' -k1,1`. Two events in the same second may swap between runs or platforms. Right: add `-k2,2n -k3,3n` (file order, then line number).
- **Treating the message as a field.** Wrong: `awk -F'|' '{ print $6 }'` cuts `too many connections | rejecting` short. Right: rebuild it with `for (i = 7; i <= NF; i++) msg = msg "|" $i`.
- **Forgetting that syslog has no year.** Wrong: comparing `Nov 12 03:14:11` with the window as text. Right: build `year-month-day time` with the year from FROM and a month lookup table.
- **Space-padded days.** Wrong: `Nov  9` becomes `2026-11- 9 ...` and falls outside the window. Right: `gsub(/ /, "0", day)`.
- **Printing before validating.** Wrong: header lines on stdout and then `cannot read missing.log`. Right: check every file first, then print.
- **Using interval regexes.** Wrong: `/^[0-9]{4}-/` silently fails in some awks. Right: spell it out with `[0-9][0-9][0-9][0-9]-`.
