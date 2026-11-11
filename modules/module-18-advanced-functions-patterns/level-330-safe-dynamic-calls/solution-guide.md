# Walkthrough: Safe Dynamic Calls

## The plan

Calling `"do_$action"` is a dynamic call: the code that runs depends on
data. The data comes from a web form, so treat it as hostile. The defence is
an allow-list in the script: what may be called is decided by you, and the
input can only pick from it.

## Step by step

Write the list as an array and a small function for the exact-match test:

```bash
allowed=(restart reload status)

is_allowed() {
  local candidate=$1 item
  for item in "${allowed[@]}"; do
    [[ $item == "$candidate" ]] && return 0
  done
  return 1
}
```

The quotes around `"$candidate"` matter: unquoted, the right side of `==`
inside `[[ ]]` is a *pattern*, and an input like `*` would match everything.

Read the input two words at a time. `read -r action target` puts the first word
in `action` and the rest of the line in `target`. A blank line leaves `action`
empty:

```bash
refused=0
while read -r action target; do
  [[ -z $action ]] && continue
```

Refuse before calling. A refusal is reported on stderr and remembered, and the
loop moves on to the next line:

```bash
  if ! is_allowed "$action"; then
    echo "refused: '$action' is not an allowed action" >&2
    refused=1
    continue
  fi
  "do_$action" "$target"
done
(( refused == 0 )) || exit 3
```

## Things the tests try

- `wipe`: the function exists, but it is not on the list.
- `restart; touch pwned`: the action word is `restart;`, which is not an exact match.
- `do_restart`: already carries the prefix, still not on the list.
- `stat`: a prefix of an allowed name must not match.

## Try it by hand

```
printf 'status marlin\nwipe marlin\n' | ./solution.sh; echo "exit=$?"
```

## Alternative

A `case "$action" in restart|reload|status) ... ;; *) refuse ;; esac` is the
same idea in other syntax. The array version has one list you can also print
for a help message.
