# Walkthrough: Required Keys

## The plan

A validation step that stops at the first problem makes people play whack-a-mole:
fix one thing, run again, meet the next. The better design is to examine
everything, print every complaint, and fail once at the end with a count. That
needs two parts: a way to look up any key after one pass over the file, and a
counter.

## Building it

Start with the arguments. After the usage check, `shift` removes the file name so
`"$@"` is the list of required keys and `$#` is how many there are:

```bash
file=$1
shift
```

Read the file once into an associative array. `IFS='=' read -r key rest` splits at
the first `=` so values such as `abc=def==` stay whole. Trim both parts, skip
empty names and lines whose name starts with `#`, and store
`value[$key]=$rest`. Storing every line in turn means a later line for the same
key replaces an earlier one, which gives "the last one counts" for free.

Now the check. A key is missing if it is absent or empty, and
`${value[$key]:-}` is empty in both cases, so one test covers both:

```bash
missing=0
for key in "$@"; do
  if [[ -z ${value[$key]:-} ]]; then
    echo "missing: $key" >&2
    missing=$(( missing + 1 ))
  fi
done
```

Use `missing=$(( missing + 1 ))` rather than `(( missing++ ))`: the latter returns
status 1 when the old value is 0, and `set -e` would end the script on the first
missing key, exactly what we are trying to avoid.

Last, decide: if the count is positive print the summary to stderr and `exit 1`;
otherwise print the ok line.

## Trying it by hand

```
printf 'A=1\nB=\n' > t.env
./solution.sh t.env A B C; echo "status $?"
```

## Alternative

Checking each key with `grep -q "^$key=.\+" file` also works but starts one
process per key and trips over spaces around `=`. One pass into an array is
quicker and more precise.
