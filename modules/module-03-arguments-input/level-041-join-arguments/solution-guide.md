# Walkthrough: Join Arguments

## The plan
Joining words with a separator is normally a loop with a special case for the
last item. Bash has a shortcut: `"$*"` already joins the arguments, and `IFS`
decides what goes between them.

## Building it
By default the glue is a space:

```bash
echo "affected: $*"      # eel flounder grouper
```

`IFS` (Internal Field Separator) is the variable behind this. Its first
character is what `"$*"` inserts between arguments. Set it to a comma:

```bash
IFS=,
echo "affected: $*"      # eel,flounder,grouper
```

With a single argument there is nothing to join, so no comma appears: the edge
case that bites hand-written loops simply does not exist.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=,
echo "affected: $*"
```

## Try it by hand
```bash
./solution.sh eel flounder grouper
./solution.sh "blue whale" marlin     # blue whale,marlin
```

## Alternative
A loop that appends `,$name` and then trims the first comma works, but it is
longer and easy to get wrong. Piping through `paste -sd,` also works for lines of
input, not for arguments. `"$*"` with `IFS` stays the cleanest way when the words
are already in `$@`. Note it can only glue with ONE character: to join with
`", "` you would need a different technique later on.
