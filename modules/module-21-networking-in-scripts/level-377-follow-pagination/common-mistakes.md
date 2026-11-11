# Common Mistakes

- **Fetching only the first page.** The output looks plausible and is quietly incomplete. Always ask what the last page looks like and loop until you get there.
- **No page limit.** If the server's `next` never turns null, `while [[ -n $next ]]` runs forever.
  - Right: count pages and stop at a sane maximum.
- **Treating `null` as text.** If your extraction returns the word `null`, the loop condition `-n` stays true and you fetch `.../invoices` + `null` until the server errors.
  - Right: match only quoted values, or compare explicitly: `[[ $next == null ]]`.
- **Letting an empty page kill the script.** `grep` finds no ids on an empty page and exits 1; with `pipefail` that aborts everything.
  - Right: `... || true`
- **Counting with `wc -l` unguarded.** On an empty list `printf '%s\n' ""` still prints one empty line and counts 1.
  - Right: only count when the list is non-empty.
