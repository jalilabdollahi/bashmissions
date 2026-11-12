# Common Mistakes

- **Grepping for the key without the section.** Wrong: `grep '^port=' site.ini` returns the first `port` of the file, which may belong to `[web]`. Right: track which header you are under and match only inside the wanted section.
- **Never leaving the section.** Wrong: setting `inside=1` on the wanted header and forgetting to reset it on the next one reads keys from every later section. Right: each header sets `inside` to 1 or 0.
- **Splitting on every `=`.** Wrong: `cut -d= -f2` turns `url=https://x/?a=b` into `https://x/?a`. Right: `${line#*=}` removes only up to the first `=`.
- **Stripping "inline comments".** Wrong: `value=${value%%#*}` cuts `https://x/#top` to `https://x/`. Right: only whole-line comments are comments in this dialect.
- **Stopping at the first match.** Wrong: `break` after the first hit ignores a later override in a repeated section. Right: keep overwriting `result` until the file ends.
