# Walkthrough: Changelog from Commits

## The plan
The commit history is already structured: each subject says what *kind* of
change it is. A changelog generator reads them all, sorts them into buckets,
and prints each bucket under its own heading. Reading everything before
printing anything is what lets us skip empty sections and keep a fixed order.

## Steps
Four arrays are the buckets:

```bash
breaking=() features=() fixes=() other=()
```

One regex splits a conventional subject. Optional groups still occupy a slot in
`BASH_REMATCH`, empty when they did not match:

```bash
re='^([a-z]+)(\(([^)]+)\))?(!)?: (.+)$'
# [1]=type [3]=scope [4]=! [5]=text
```

Inside the read loop, skip noise first (`[[ -z $subject || $subject == "Merge "* ]] && continue`).
When the regex matches, build the bullet (with a scope prefix if there is one)
and route it: a `!` wins over everything, then `feat`, then `fix`, and any
other type like `docs` goes to Other *with the subject as written*. A subject
that does not match at all, for example `Tweak the harbour colours` or
`Fix: Capital letters`, also lands in Other.

Printing uses a small function so every section follows the same rule: do
nothing if empty, else a blank line, a heading and the bullets.

```bash
section() {
  local title=$1; shift
  (( $# > 0 )) || return 0
  printf '\n### %s\n' "$title"
  printf '%s\n' "$@"
}
```

`printf '%s\n' "$@"` reuses the format for every argument. The empty-array
idiom `${list[@]+"${list[@]}"}` keeps older Bash happy under `set -u`.

## Try it by hand
```bash
printf 'feat(ui): dark mode\nfix: typo\n' | ./solution.sh v1.4.0
```

## Alternative
You could print as you read, using one pass per section (`grep '^feat'`
four times). That rereads the input and cannot take the commits from a
pipe, so collecting into arrays in a single pass is better.
