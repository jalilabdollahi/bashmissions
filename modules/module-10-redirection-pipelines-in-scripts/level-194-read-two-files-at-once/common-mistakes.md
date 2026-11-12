# Common Mistakes

- **Reading both files from stdin.** The second read steals lines from the first.
  - Wrong: `while read -r name; do read -r address; ...; done < "$1"` then wondering where lines vanish
  - Right: `read -r -u 3 address` with the addresses on fd 3
- **Reopening the second file in the loop.** You always get its first line.
  - Wrong: `read -r address < "$2"` inside the loop
  - Right: `exec 3< "$2"` once, before the loop
- **Forgetting `-r`.** Backslashes in the data are eaten.
  - Wrong: `read name` turns `C:\temp` into `C:temp`
  - Right: `IFS= read -r name`
- **Ignoring end of file.** A stale value from the last iteration appears.
  - Wrong: `read -r -u 3 address` and then using `$address` unchecked
  - Right: `read -r -u 3 address || address="(none)"`
