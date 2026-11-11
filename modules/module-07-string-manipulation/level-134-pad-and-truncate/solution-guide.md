# Walkthrough: Pad and Truncate

## The plan
Split each line into NAME and PLAN, then print both with one `printf` format that
fixes the width of each column.

## Reading the fields
`IFS=,` tells `read` to split at commas instead of at spaces. With two variable
names, the first field goes into `name` and the rest of the line into `plan`:

```bash
while IFS=, read -r name plan || [[ -n $name ]]; do
```

## The format
A `%s` conversion accepts `%[flags][width][.precision]s`:

| spec | meaning |
|---|---|
| `%14s` | at least 14 wide, right-aligned |
| `%-14s` | at least 14 wide, left-aligned (the minus) |
| `%.14s` | at most 14 characters: longer strings are cut |
| `%-14.14s` | exactly 14, left-aligned |

So the name column is `%-14.14s` and the plan column (right-aligned, exactly 8)
is `%8.8s`. The bars are plain text so you can see where the columns end:

```bash
printf '|%-14.14s|%8.8s|\n' "$name" "$plan"
```

Always pass the data as arguments, never inside the format, because a `%` in the
data would otherwise be read as a conversion.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
while IFS=, read -r name plan || [[ -n $name ]]; do
  printf '|%-14.14s|%8.8s|\n' "$name" "$plan"
done
```

## Try it by hand
```bash
printf 'Dory Bikes,basic\nGull & Anchor Pub,business\n' | ./solution.sh
```

## Alternative
You could pad with a loop and slice with `${name:0:14}`, but that is a page of
code for what one format does. The `printf` route is also how every report
generator in shell scripts is written.
