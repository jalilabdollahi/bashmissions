# Common Mistakes

- **Forgetting `g`.**
  Wrong: `sed 's/lanternfish\.internal/example.test/'` (only the first one per line).
  Right: add `g` at the end.
- **An unescaped dot in the pattern.** `s/lanternfish.internal/.../g` also rewrites
  `lanternfishXinternal`. Write `\.`.
- **Escaping the dot in the replacement.** `s/a/b\.c/` gives `b.c` in most seds, but
  there is no reason to; the replacement is plain text.
- **Fighting slashes.** `s/\/srv\/lanternfish/\/srv\/app/g` works and nobody can read
  it. Use another delimiter: `s|/srv/lanternfish|/srv/app|g`. (If the text contains
  your delimiter, pick another one.)
- **Using `sed -i` without a suffix.** macOS needs `-i ''` while GNU sed takes plain
  `-i`; use `-i.bak` which works on both, or print to stdout like here.
