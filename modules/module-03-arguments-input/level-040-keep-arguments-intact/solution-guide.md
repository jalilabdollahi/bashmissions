# Walkthrough: Keep Arguments Intact

## The plan
The wrapper does one thing: run `bash fixtures/tag.sh` and give it exactly the
arguments the wrapper got. The whole level is about how to write "exactly".

## Building it
First see the problem. The naive version:

```bash
bash fixtures/tag.sh $@
```

Run `./solution.sh "Tidewater Books"` and you get `<Tidewater>` and `<Books>`.
Unquoted `$@` takes the arguments back out of their quotes and lets the shell
split on spaces (and expand `*.txt` as a glob!) a second time.

The fix is two quote characters:

```bash
bash fixtures/tag.sh "$@"
```

`"$@"` is special: although it sits inside double quotes, it expands into
*separate words*, one per original argument, each already protected.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
bash fixtures/tag.sh "$@"
```

## Try it by hand
```bash
./solution.sh "Tidewater Books" dory
./solution.sh "" flounder        # the empty label must still appear
```
Then temporarily remove the quotes and watch both outputs break.

## Alternative
`"$*"` (all arguments glued into ONE word) is the other quoted form. It is the
right tool for building a message string (next level), and the wrong tool here,
because the printer would see a single argument.
