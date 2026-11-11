# Common Mistakes

- **Trusting `cp`'s exit status as proof.** Disks fill up, shares disconnect.
  - Wrong: `cp "$src" "$dest" && echo "copied"`
  - Right: `cp "$src" "$dest"` followed by `cmp -s "$src" "$dest"`
- **Overwriting silently.** `cp` replaces an existing destination without asking.
  - Wrong: `cp "$src" "$folder/"` over a precious file
  - Right: test `[[ -e $dest ]]` first and refuse
- **Leaving the corrupt copy behind.** Later readers cannot tell it is broken.
  - Wrong: print an error and `exit 3` without cleaning up
  - Right: `rm -f "$dest"` before reporting
- **Using `cmp` without `-s` in an `if`.** On a difference it prints a message into your output.
  - Wrong: `if ! cmp "$src" "$dest"; then`
  - Right: `if ! cmp -s "$src" "$dest"; then`
