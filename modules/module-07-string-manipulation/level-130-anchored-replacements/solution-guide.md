# Walkthrough: Anchored Replacements

## The plan
Read the paths one by one. Apply the "start" replacement, then the "end"
replacement. Each only fires when the text is at that edge of the value.

## Two anchors
After the first slash of a replace expansion you may put an anchor:

- `${v/#old/new}` : `old` must match at the **start** of `v`
- `${v/%old/new}` : `old` must match at the **end** of `v`

(Remember the mnemonic from the trimming levels: `#` is left, `%` is right.)

Without anchors, `/var/log/legacy/` inside `/backup/var/log/legacy/db.txt` would
match and be replaced; with `/#` the value must begin with it, so the backup path
is left alone.

## Keeping the slashes readable
The paths are full of slashes, which are separators in this syntax, so each one
must be escaped. Putting the texts into variables avoids the clutter:

```bash
old_dir=/var/log/legacy/
new_dir=/var/log/lanternfish/
path=${path/#"$old_dir"/$new_dir}
path=${path/%.log/.log.gz}
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
while IFS= read -r path || [[ -n $path ]]; do
  path=${path/#\/var\/log\/legacy\//\/var\/log\/lanternfish\/}
  path=${path/%.log/.log.gz}
  echo "$path"
done
```

## Try it by hand
```bash
printf '/var/log/legacy/nginx/access.log\n/backup/var/log/legacy/db.txt\n' | ./solution.sh
```

## Alternative
A regular expression with `^` and `$` anchors does the same job in `sed`:
`sed -E 's|^/var/log/legacy/|/var/log/lanternfish/|; s|\.log$|.log.gz|'`. That is
fine for files, but for a value already in a variable the anchored expansion needs
no extra process, and no regex dialects to remember.
