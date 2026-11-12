# Common Mistakes

- **Deleting before verifying.** `gzip -c f > f.gz && rm f` still removes the original even if `f.gz` is truncated (a full disk is the classic cause).
  - Right: `gzip -t` the copy first, then `rm`.
- **Piping `find` into `while`.** The loop runs in a subshell, so `archived=$((archived+1))` is lost when the pipe ends.
  - Right: `done < <(find ... | sort)`
- **Forgetting `-maxdepth 1`.** Without it find walks into `archive/` and `old/` and re-archives things you did not mean to touch.
  - Right: `find "$dir" -maxdepth 1 -type f ...`
- **`for f in $(find ...)`.** A log called `pier pos.log` becomes two words.
  - Right: read whole lines with `IFS= read -r`.
- **Overwriting an earlier archive.** Re-running after a partial failure replaces `web.log.gz` with the compressed copy of a newer, different `web.log`.
  - Right: check `[[ -e $out ]]` and skip.
