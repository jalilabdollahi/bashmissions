# Walkthrough: Split on a Delimiter

## The plan
Cut the line at every colon into pieces, store the pieces in an array, and print
the four you need by position.

## One new idea: an array from `read -a`
An **indexed array** is a variable that holds a numbered list of values. You have
seen `"$@"` behave like one. `read -a name` splits its input into that kind of
list. The number of the first element is **0**, not 1.

```bash
IFS=: read -ra fields <<< "$line"
```

Taking it apart:

- `IFS=:` makes the colon the separator. Written in front of the command, it
  applies to that command only and does not change the rest of the script.
- `-r` keeps backslashes literal (good habit).
- `-a fields` stores the pieces in the array `fields`.
- `<<< "$line"` hands the string to `read` as its input. It is called a
  *here-string*.

For `ollie:x:1002:1002:Ollie Quinn:/home/ollie:/bin/bash` the array is:

| index | 0 | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|---|
| value | ollie | x | 1002 | 1002 | Ollie Quinn | /home/ollie | /bin/bash |

Read element 2 with `${fields[2]}`. An empty comment field is still an element
(an empty one), so the later indexes do not move.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
line=$1
IFS=: read -ra fields <<< "$line"
echo "user=${fields[0]}"
echo "uid=${fields[2]}"
echo "home=${fields[5]}"
echo "shell=${fields[6]}"
```

## Try it by hand
```bash
./solution.sh "mara:x:1001:1001::/home/mara:/bin/zsh"
```

## Alternative
`echo "$line" | cut -d: -f6` fetches one field per process. With the array
the line is split once and every field is free after that.
