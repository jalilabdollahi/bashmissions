# Walkthrough: sed Substitution

## The plan
`sed` reads lines, applies editing commands, and prints the result. The `s`
command substitutes: `s/pattern/replacement/flags`.

## The domain
```
s/lanternfish\.internal/example.test/g
```
- The pattern is a regex, so `.` would match any character. `\.` is the real dot;
  without it `lanternfishXinternal` would be rewritten too.
- In the *replacement* a dot is just a dot, no escape needed.
- The `g` flag means "global on the line". Without it only the first match per
  line is replaced, and `a.lanternfish.internal -> b.lanternfish.internal` would
  keep its second name.

## The path
`s/\/srv\/lanternfish/\/srv\/app/g` works but is unreadable. The character right
after `s` is the delimiter, and it can be anything, so `s|/srv/lanternfish|/srv/app|g`
reads naturally.

## Two commands, one sed
Give each command its own `-e`: `sed -e 's/.../.../g' -e 's|...|...|g' file`. They
run on every line, in order.

## No in-place edit
Without `-i`, sed never changes the file; it writes to stdout. The caller decides
where it goes: `./solution.sh app.log > clean.log`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LOGFILE" >&2
  exit 2
fi
sed -e 's/lanternfish\.internal/example.test/g' \
    -e 's|/srv/lanternfish|/srv/app|g' "$1"
```

## Try it by hand
```bash
printf 'a.lanternfish.internal b.lanternfish.internal\n' > t.log
./solution.sh t.log
```

## Alternative
Parameter expansion, `${line//lanternfish.internal/example.test}`, does the same
job inside a Bash loop (there the pattern is a glob, so dots are literal). It is
fine for a variable, but `sed` is the right tool for a whole file.
