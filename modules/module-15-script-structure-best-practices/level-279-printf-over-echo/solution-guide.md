# Walkthrough: printf Over echo

## The plan
Swap `echo` for `printf` with a constant format. Behaviour for ordinary words is
identical; behaviour for awkward words becomes correct.

## What echo does wrong
`echo "$tag"` with `tag=-n` runs `echo -n`, which prints nothing and suppresses
the newline. With `-e` it turns on backslash interpretation, so `a\tb` may become
a tab. Different shells and systems also disagree (`sh` on some systems always
interprets backslashes). The result depends on the data and on the platform.

## Steps
1. Replace the loop body:
   ```bash
   printf '%s\n' "$tag"
   ```
   `%s` means "insert the next argument as text". The `\n` in the format is the only
   escape processed, and it comes from you, not from the data.
2. Replace the count line:
   ```bash
   printf 'count: %d\n' "$#"
   ```
3. Never use the data as the format. `printf "$tag\n"` with `tag=50%d` would try to
   read a number that is not there.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
for tag in "$@"; do
  printf '%s\n' "$tag"
done
printf 'count: %d\n' "$#"
```

## Try it
```
./solution.sh -n -e 'C:\new' 50%d
```

## Alternative
`printf '%s\n' "$@"` prints every argument in one command, because printf reuses
its format for leftover arguments. It is shorter, but with zero arguments it prints
one empty line, which this task would not want.
