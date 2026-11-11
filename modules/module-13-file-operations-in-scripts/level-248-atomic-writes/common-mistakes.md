# Common Mistakes

- **Making the temp file in `/tmp`.** If `/tmp` is another disk, `mv` degrades to copy + delete, and the swap is no longer atomic.
  - Wrong: `tmp=$(mktemp)` then `mv "$tmp" config/app.conf`
  - Right: `tmp=$(mktemp config/.app.conf.XXXXXX)`
- **Writing straight into the live file.** Readers see it empty or half full.
  - Wrong: `cat > config/app.conf`
  - Right: `cat > "$tmp"` then `mv "$tmp" config/app.conf`
- **Skipping the validation.** An atomic swap of a broken file is still a broken file.
  - Wrong: `mv "$tmp" config/app.conf` immediately
  - Right: `grep -Eq ... "$tmp"` first, delete the temp file when it fails
- **Forgetting the permissions.** `mktemp` files are mode 600, owned by you.
  - Wrong: `mv "$tmp" config/app.conf` and the web server gets "permission denied"
  - Right: `chmod 644 "$tmp"` before the move
- **Leaving the temp file behind on the failure path.**
  - Wrong: `grep -Eq ... "$tmp" || exit 1`
  - Right: `rm -f "$tmp"` first, or a `trap 'rm -f "$tmp"' EXIT`
