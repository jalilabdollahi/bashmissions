# Common Mistakes

- **Downloading straight to the final name.** A crash or a failed check leaves a bad file where others will trust it.
  - Right: `curl -o "$tmp" ...`, verify, then `mv "$tmp" "$name"`.
- **Forgetting `--fail` on downloads.** A missing file saves the text `404 Not Found` as your archive.
  - Right: `curl -sS --fail -o "$tmp" "$url"`
- **Comparing whole `cksum` lines.** `cksum file` includes the file name, which differs from your temp name.
  - Wrong: `[[ $(cksum "$tmp") == "$published" ]]`
  - Right: `cksum < "$tmp"` and compare only `CRC SIZE`.
- **Comparing only the CRC.** The size is free extra evidence and catches truncation at once.
- **No cleanup on failure.** Temporary files pile up unless a `trap ... EXIT` removes them on every exit path.
