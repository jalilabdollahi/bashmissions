# Walkthrough: Flags, Positionals and --

## The plan
Options come first and are consumed one at a time; whatever remains afterwards is
the list of words. A `while`/`case`/`shift` loop is the standard shape.

## Steps
1. Loop while arguments remain: `while [ "$#" -gt 0 ]; do`.
2. Inside, `case "$1" in` decides what the argument is:
   - `-u|--upper)` sets a flag and `shift`s it away.
   - `-p|--prefix)` takes a value. First check `[ "$#" -lt 2 ]`, because the flag may
     be the last argument; if so, complain with `exit 2`. Otherwise `prefix=$2`
     and `shift 2` to remove both.
   - `--)` means "no more options": `shift` it and `break`.
   - `-*)` is any other dash word: an unknown option, exit 2.
   - `*)` is the first positional: `break` without shifting, so the word stays.
3. After the loop, `"$@"` contains only the words. If there are none, print the usage
   line to stderr and exit 2.
4. Print each word: `printf '%s%s\n' "$prefix" "$word"`, upper-casing first if
   requested.

The order of the `case` branches matters: specific patterns before the catch-all
`-*)`, and `-*)` before `*)`.

## Complete solution
See answer.sh in the level folder.

## Try it
```
./solution.sh -u -p '* ' cod haddock
./solution.sh -- -n          # the word -n
./solution.sh -x cod; echo $?
```

## Alternative
`getopts` handles short options (`-u -p VALUE`) and is built in, but it cannot do
long options like `--prefix`. The manual loop is more flexible and fits in 20 lines.
