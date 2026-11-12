# Walkthrough: Filenames with Spaces

## The plan
The logic is fine; every unquoted expansion is a bug waiting for a customer with a
space in their file name. We add quotes everywhere, with one subtlety: the glob.

## What goes wrong
With `$1/*.txt` unquoted and `$1` equal to `Tide Books`, bash splits the word into
`Tide` and `Books/*.txt` before it globs. With `$f` unquoted and `f="Pub *final*.txt"`,
the shell splits on the space and then expands `*final*.txt` against the current
folder, so `cp` receives names you never meant.

## Steps
1. Quote the variable part of the glob, leave the wildcard bare:
   ```bash
   for f in "$1"/*.txt; do
   ```
   A glob expansion produces one word per match, however strange the name; the loop
   variable receives each whole name.
2. Quote the test, the `basename` argument, the copy and the echo:
   ```bash
   if [ -e "$f" ]; then
     name=$(basename "$f")
     cp "$f" "archive/$name"
     echo "archived: $name"
   ```
3. When nothing matches, the pattern stays as literal text `dir/*.txt`, which is
   why `[ -e "$f" ]` guards the body.
4. Quote `"$count"` in the final test as well. It is a number here, but the habit is
   the point.

## Complete solution
See answer.sh in the level folder, or assemble the pieces above.

## Try it
```
mkdir -p inbox && echo hi > "inbox/Q3 sales.txt"
./solution.sh inbox
ls archive
```

## Alternative
Setting `shopt -s nullglob` makes an unmatched glob expand to nothing, removing
the `-e` test. That is a fine alternative, but it changes shell state for the whole
script, so the explicit check is the more portable habit.
