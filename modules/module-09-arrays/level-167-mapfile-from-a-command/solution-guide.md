# Walkthrough: mapfile from a Command

## The plan
Run `find` and `sort` to produce the list, let `mapfile` load it into an array, then print the count and each file's bare name.

## Step by step
1. Check the argument is a directory with `[[ -d $dir ]]`. If not, print the message to stderr and exit 1. Without this check `find` would complain with its own, different message.
2. Build the command: `find "$dir" -maxdepth 1 -name '*.conf' | sort`. `-maxdepth 1` stays in the top directory; the quoted `'*.conf'` is a pattern for `find`, not for the shell. `sort` makes the order identical on every machine, as `find` returns entries in directory order.
3. Load its output: `mapfile -t confs < <( ... )`. The `<( ... )` runs the command and presents its output as a file name; `<` redirects that into `mapfile`.
4. Print `found: ${#confs[@]}`. With no matches this is 0 and the loop never runs.
5. Loop over the array and print `${path##*/}`, which deletes the longest prefix ending in a slash and leaves the file name. Names with spaces are safe because the array elements are quoted.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1
if [[ ! -d $dir ]]; then
  echo "not a directory: $dir" >&2
  exit 1
fi
mapfile -t confs < <(find "$dir" -maxdepth 1 -name '*.conf' | sort)
echo "found: ${#confs[@]}"
for path in "${confs[@]}"; do
  echo "${path##*/}"
done
```

## Trying it by hand
`mkdir d; touch d/a.conf "d/b c.conf" d/x.txt; bash solution.sh d` lists two files. Then swap `< <(...)` for `find ... | mapfile -t confs` and watch the count drop to 0.

## An alternative
`confs=("$dir"/*.conf)` uses a glob and needs no command at all, but it returns the literal pattern when nothing matches. When the list really is "the output of a command" (a `grep -l`, a `sort -u`), process substitution is the general tool.
