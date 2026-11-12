# Common Mistakes

- **No timeout on the probe.** A filtered port makes plain `nc host port` wait for minutes, and 6 ports times 30 hosts stalls the report.
  - Right: `nc -z -w 1 host port`
- **Matching ports as substrings.** `[[ $list == *80* ]]` is true for `8080`, `180` and `5480`.
  - Right: pad the list, `" 22 80 "`, and test `*" $port "*`.
- **Leaving nc's error text visible.** A host that does not resolve prints a message for every port and buries your table.
  - Right: `if nc -z -w 1 ... 2>/dev/null; then`
- **Treating an empty open list as an empty string.** `open=` with nothing after it looks like a bug.
  - Right: `${open_list:--}` prints a dash.
- **Forgetting the empty-array trap.** With `set -u` on older Bash, `"${notes[@]}"` errors when `notes` is empty.
  - Right: `"${notes[@]+"${notes[@]}"}"`
