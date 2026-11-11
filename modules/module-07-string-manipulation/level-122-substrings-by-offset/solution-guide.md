# Walkthrough: Substrings by Offset

## The plan
The stamp never changes shape, so each field lives at a known position. Slice
each field into a variable, then print them with the punctuation Gus wants.

## Counting the positions
Write the stamp and number it from zero:

```
20241107T093015
0123456789...
```

Year is 4 characters from offset 0, month 2 from offset 4, day 2 from offset 6.
Offset 8 is the letter `T`, which we skip. Hour starts at 9, minute at 11,
second at 13.

## Building it
The syntax is `${name:offset:length}`:

```bash
stamp=$1
year=${stamp:0:4}
month=${stamp:4:2}
day=${stamp:6:2}
hour=${stamp:9:2}
minute=${stamp:11:2}
second=${stamp:13:2}
```

Then print, adding the dashes and colons yourself:

```bash
echo "date=$year-$month-$day"
echo "time=$hour:$minute:$second"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
stamp=$1
year=${stamp:0:4}
month=${stamp:4:2}
day=${stamp:6:2}
hour=${stamp:9:2}
minute=${stamp:11:2}
second=${stamp:13:2}
echo "date=$year-$month-$day"
echo "time=$hour:$minute:$second"
```

## Try it by hand
```bash
./solution.sh 20241107T093015
./solution.sh 20250101T000000
```
You can also experiment straight in the terminal: `s=20241107T093015; echo "${s:4:2}"`.

## Alternative
`echo "$stamp" | cut -c5-6` does the same job but starts a process per field. The
built-in slice is quicker, and it keeps the leading zeros, which matter here
because these are text, not numbers.
