# Common Mistakes

- **Trusting the archive's file names.** Wrong: running `tar -xzf` first and looking later. An entry like `../evil.txt` lands outside the scratch directory. Right: `tar -tzf`, reject `/...` and `..` components, then extract.
- **Leaking the scratch directory.** Wrong: `rm -rf "$work"` at the end of the script, skipped when `exit 2` or an error comes first. Right: `trap 'rm -rf "$work"' EXIT` right after `mktemp -d`.
- **Comparing `cksum file` output.** Wrong: the output contains the file name, so it never equals `CRC SIZE`. Right: `cksum < "$f"`, which prints only the two numbers.
- **Sorting dates ascending.** Wrong: `sort -k2,2` makes "first N" the *oldest* backups. Right: reverse the date key, `-k2,2r`.
- **Splitting the set name on the first dash.** Wrong: `${base%%-*}` turns `harbor-logs-2026-11-10` into `harbor`. Right: a regex that anchors on the trailing date.
- **Reporting only counts.** Wrong: "2 failed". Right: say which file is missing or differs, so the fix can start immediately.
