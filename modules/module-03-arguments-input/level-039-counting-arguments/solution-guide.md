# Walkthrough: Counting Arguments

## The plan
The names themselves do not matter, only how many of them arrived. Bash tracks
that for you in `$#`, so the script is a single `echo`.

## Building it
Try the variable on its own first, with a throwaway script:

```bash
echo "$#"
```

Run it as `./solution.sh a b c` and it prints `3`. Run it with no arguments and it
prints `0`, no special handling required. Then wrap it in the sentence from the
objective:

```bash
echo "batch size: $#"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
echo "batch size: $#"
```

## Try it by hand
```bash
./solution.sh anchovy barracuda dory     # batch size: 3
./solution.sh                            # batch size: 0
./solution.sh "blue whale" eel           # batch size: 2
./solution.sh blue whale eel             # batch size: 3
```
The last two lines look almost the same and give different answers. Quotes
decide what counts as one argument.

## Alternative
You could run `set -- "$@"` tricks or loop and count by hand, but that is a lot of
code to reproduce a number Bash already has. `$#` also works inside functions,
where it counts that function's arguments.
