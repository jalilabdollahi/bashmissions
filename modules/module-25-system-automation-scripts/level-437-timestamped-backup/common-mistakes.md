# Common Mistakes

- **Archiving the full path.** `tar -czf b.tar.gz /srv/www/site` stores `srv/www/site/...`, and restores land in a deep tree.
  - Right: `tar -czf b.tar.gz -C /srv/www site`
- **Forgetting the trailing slash case.** `basename site/` is fine, but `dirname site/` and string building around it can produce `site/-20260301`.
  - Right: strip it first with `src=${1%/}`.
- **Overwriting silently.** `tar -czf` happily replaces an existing file of the same name, so a repeated run destroys the earlier backup.
  - Right: `[[ -e $archive ]] && exit 1` before tar runs.
- **Counting directories as files.** `tar -tzf` prints `www/` and `www/css/` too, so a plain `wc -l` over-counts.
  - Right: `grep -vc '/$'`
- **`grep -c` killing the script.** With an archive holding no regular files, `grep -c` exits 1 and `set -e` stops everything.
  - Right: `... | grep -vc '/$' || true`
