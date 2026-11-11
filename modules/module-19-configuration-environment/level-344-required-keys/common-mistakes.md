# Common Mistakes

- **Exiting on the first missing key.** Wrong: `echo "missing: $key" >&2; exit 1` inside the loop reports one problem per run. Right: print, count, and exit once after the loop.
- **Counting with `(( missing++ ))` under `set -e`.** Wrong: the first miss evaluates to 0, the command returns 1 and the script dies silently. Right: `missing=$(( missing + 1 ))`.
- **Counting present-but-empty as present.** Wrong: `[[ -v value[$key] ]]` is true for `TIER=`. Right: `[[ -z ${value[$key]:-} ]]` treats absent and empty alike.
- **Using `$#` after the loop's `shift` confusion.** Wrong: forgetting `shift` makes the file name a "required key" and counts N+1. Right: `file=$1; shift`, then `$#` is the key count.
- **Letting comments define keys.** Wrong: `# DB_USER=bakery` stored as a value of the name `# DB_USER`, or worse, matched by a sloppy grep. Right: skip lines whose name starts with `#`.
