# Common Mistakes

- **Leaving the pattern unquoted.** The shell expands it against the current folder first.
  - Wrong: `find "$folder" -name $pattern`
  - Right: `find "$folder" -name "$pattern"`
- **Putting a path in the pattern.** `-name` only sees the last component.
  - Wrong: `find . -name 'srv/*.conf'` (never matches)
  - Right: `find srv -name '*.conf'`
- **Expecting a case-insensitive match.** `-name` is exact about capitals.
  - Wrong: assuming `*.conf` finds `X.CONF`
  - Right: say so in the pattern (`'*.[cC][oO][nN][fF]'`) or use `-iname`
- **Trusting the order of the output.** It differs between systems and runs.
  - Wrong: using `find ... | head -n 1` as "the first one"
  - Right: `find ... | sort | head -n 1`
- **Counting with `echo | wc -l` when nothing matched.** An empty string still prints one empty line, so the count is 1.
  - Wrong: `count=$(echo "$matches" | wc -l)` with no matches
  - Right: handle the empty case first
