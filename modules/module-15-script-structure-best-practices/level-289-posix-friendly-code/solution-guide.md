# Walkthrough: POSIX-Friendly Code

## The plan
Same behaviour, plainer tools. Translate each bash feature to its POSIX cousin, then
test with a plain `sh`.

## Translation table, as it applies here
1. Shebang: `#!/bin/sh`. Options: `set -eu` (pipefail is not in older POSIX shells).
2. Argument count: `if [ "$#" -eq 0 ]; then` replaces `(( $# == 0 ))`.
3. Lower-casing: `lower=$(printf '%s' "$path" | tr '[:upper:]' '[:lower:]')`
   replaces `${path,,}`.
4. File tests: `[ ! -e "$path" ]` and `[ -d "$path" ]`, with every variable quoted,
   because single brackets are an ordinary command that splits unquoted words.
5. The chain of `[[ $lower == *.png || ... ]]` becomes one `case`:
   ```sh
   case "$lower" in
     *.png|*.jpg|*.jpeg|*.gif) kind=image ;;
     *.tar.gz|*.tgz|*.zip)     kind=archive ;;
     *.log)                    kind=log ;;
     *)                        kind=other ;;
   esac
   ```
   `case` does glob matching natively and is available everywhere.
6. Counter: `count=$((count + 1))`. The POSIX arithmetic expansion is fine; the
   standalone `((count++))` is bash only (and would also exit 1 on 0 under `set -e`).
7. Output: `printf '%s: %s\n' ...` rather than `echo`.

## Try it
```
sh solution.sh Beach.PNG notes.txt missing.log
dash solution.sh Beach.PNG        # if dash is installed
```

## Alternative
You could keep bash and `#!/usr/bin/env bash` and simply require bash 4. That is
fine for your own machines; POSIX is the right target when the script must run in
minimal containers, installers, or on the recovery stick.
