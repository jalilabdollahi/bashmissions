# Debrief: Directory Summary

## What you learned

Most reports are the same three moves: **enumerate** (find), **classify**
(turn each item into a key), **tally** (an associative array), then
**present** (sort and format). Here the classification is the interesting
part: deciding what an "extension" is takes care, and the rules live in a
handful of parameter expansions.

## Under the hood

`${name##*.}` removes the longest prefix ending in a dot, leaving the text
after the last dot, and if there is no dot nothing matches, so you get the
whole name back; that is why the code must test for a dot separately.
`${name%.*}` is the mirror image on the other end. Working on the name
instead of the path matters because a dot anywhere in a folder name would
otherwise leak into the result.

`done < <(cmd)` runs `cmd` in the background and connects its output to the
loop's input. Unlike `cmd | while`, the loop itself stays in your shell,
so the variables it sets are still there after it ends.

`sort -k2,2nr -k1,1` sorts first by field 2 numerically in reverse, and
breaks ties with field 1 in byte order (the test environment forces the
`C` locale so this is the same on every machine).

## In real work

Disk-usage by type, "what log formats do we have", inventory of a legacy
share before a migration: all of them start from a summary like this. Add
`-size` or `-mtime` to the `find` and the report answers sharper questions.

## Going further

That completes the file server clean-up. Next module: text processing, where
the same enumerate-classify-tally pattern is applied to the *contents* of
files instead of their names.
