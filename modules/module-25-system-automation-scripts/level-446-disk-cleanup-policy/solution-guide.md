# Walkthrough: Disk Cleanup Policy

## The plan

Hard-coding "delete tmp files older than a week" works until the second rule
arrives. Moving the rules into a file separates policy (what a reviewer cares
about) from mechanism (a loop and `find`). The engine is the same for any
number of rules.

## Building it

Start with the usual flag and argument checks.

Pass 1 reads every non-comment line and splits it into `pat days bytes extra`
with `read`. A rule is valid when `bytes` exists, `extra` is empty and the two
numbers match `^[0-9]+$`. The first bad rule prints its line number and the
line itself and exits before any deletion; this is the "validate everything
first" habit, because a half-applied policy is worse than none.

Pass 2 builds a `find` command from an array. Start with `-type f -name
"$pat"`. Quote the pattern: unquoted, the shell may expand `*.tmp` against
files in the current folder, and find then receives garbage. Append `-mtime
+N` only when N is above 0 and `-size +Nc` only when the byte limit is above 0
(the `c` unit means bytes). Because the pieces are array elements, no quoting
problems appear when they are expanded with `"${args[@]}"`.

Pipe `find` through `sort` for stable order. Before removing, check `-f` (an
earlier rule may have removed it), measure with `wc -c < file` and add to the
total. Only `rm` when not in dry-run mode. Counting happens in both modes so
the dry run predicts the real summary.

## Complete solution

See answer.sh.

## Trying it by hand

```
printf '*.tmp 7 0\n' > p.txt; mkdir s; touch -t 202301010000 s/a.tmp
./solution.sh -n p.txt s
```

## Alternative

`find -delete` removes in one step, but it cannot report the rule or total the
bytes, and with `-delete` before the other tests it can wipe far more than
intended.
