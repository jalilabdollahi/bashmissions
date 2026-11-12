# Walkthrough: Diff Two Configs

## The plan

Plain `diff` compares lines, so reordering a config file looks like a rewrite. What
Mara needs is a comparison of meaning: the file is a set of name/value pairs, and the
report lists names that were added, removed or given a different value. So: parse each
file into an associative array, take the union of the names, and classify each name.

## Building it

Both files need the same parser, so write it once as a function that fills an array
chosen by the caller. `local -n target=$2` makes `target` an alias for the array whose
name was passed, so the same loop can fill `old` or `new`:

```bash
load() {
  local file=$1 key val
  local -n target=$2
  while IFS='=' read -r key val || [[ -n $key ]]; do
    ...            # trim, skip comments and blank names
    target[$key]=$val
  done < "$file"
}
```

Because every line overwrites, a repeated name ends with its last value.

Now the union of names: print the keys of both arrays and let `sort -u` deduplicate
and order them. (If an array is empty, `printf` prints one blank line, so the loop
skips empty names.)

Classification needs a careful test. `[[ -z ${old[$key]} ]]` cannot tell "missing"
from "present but empty", and the task cares about that difference. `${old[$key]+set}`
expands to `set` whenever the key exists, whatever its value:

```bash
if   [[ -z ${old[$key]+set} ]]; then   echo "+ ..."
elif [[ -z ${new[$key]+set} ]]; then   echo "- ..."
elif [[ ${old[$key]} != "${new[$key]}" ]]; then echo "~ ..."
fi
```

A tiny `show` function prints `''` for empty values. Count each kind with
`n=$(( n + 1 ))`. At the end, no differences means `no differences` and status 0;
otherwise print the summary and `exit 1`, the same convention as `diff` and `cmp`.

## Trying it by hand

```
printf 'a=1\nb=2\n' > o.conf; printf 'b=3\nc=4\n' > n.conf
./solution.sh o.conf n.conf; echo "status $?"
```

## Alternative

Sort both files and use `comm` or `diff` on the result. It finds changed lines but not
"changed value of the same key", and it needs the parsing done first anyway.
