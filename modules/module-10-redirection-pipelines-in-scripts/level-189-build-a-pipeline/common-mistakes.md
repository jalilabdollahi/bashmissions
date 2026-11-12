# Common Mistakes

- **Counting without sorting first.** `uniq` only merges adjacent equal lines.
  - Wrong: `cut -d' ' -f1 log | uniq -c`
  - Right: `cut -d' ' -f1 log | sort | uniq -c`
- **Sorting counts as text.** `9` would rank above `10`.
  - Wrong: `... | uniq -c | sort -r`
  - Right: `... | uniq -c | sort -rn`
- **Filtering loosely.** A bare `404` also matches sizes and paths.
  - Wrong: `grep 404 "$log"`
  - Right: `grep -E '" 404 ' "$log"`
- **Letting grep's "no match" kill the pipeline.** With `pipefail`, exit status 1 ends the script.
  - Wrong: `grep -E '" 404 ' "$log" | cut ...` under `set -euo pipefail`
  - Right: `{ grep -E '" 404 ' "$log" || true; } | cut ...`
- **A line that ends in `|` followed by nothing.** The trailing `\` or the pipe at the end of the line is needed to continue; a pipe at the start of the next line is a syntax error.
  - Right: end the line with `|` (or `\`) and continue below
