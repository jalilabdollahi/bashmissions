# Walkthrough: Local by Default

## The plan
This is a detective job with a one-word fix. First see the symptom, then name the
shared variables, then make them private.

## Finding the bug
The loop in `main` reads `name` and `count`, calls `format_row`, then prints
`logged $name`. Inside `format_row` the first line is `name=${1^^}`. There is no
`local`, so that line assigns the same global `name` the loop is using. When the
function returns, `name` is already upper case, and `count`, `pad` are left behind
too.

## The fix
Give each helper variable a private scope:

```bash
format_row() {
  local name=${1^^}
  local count=$2
  local pad=$(( 10 - ${#name} ))
  printf '%s%*s %s\n' "$name" "$pad" "" "$count"
}
```
`printf '%*s'` takes the width from an argument, so `$pad` blank characters are
inserted after the name.

Tidy up the caller as well: in `main`, `local rows=0 total=0 name count` stops the
loop variables from becoming globals of the script.

Note the declaration style. `local x=$(cmd)` hides the exit status of `cmd` behind
local's own status, which is always 0. For command substitutions, split it:
`local x; x=$(cmd)`. Here we only use arithmetic and expansions, so one line is safe.

## Try it
```
printf 'anchovy 12\ndory 5\n' | ./solution.sh
```

## Alternative
A subshell body, `format_row() ( ... )`, also isolates every variable, but it costs
a process per call and cannot return values through variables at all.
