# Walkthrough: Arrays into Functions

## The plan
A function cannot receive an array as a value: every argument is a plain string. So pass the array's name, and give the function a way to treat that string as the variable it names. That is a name reference.

## Step by step
1. The starter splits the arguments at `--` into `web` and `db`. Read it to see the pattern: a flag `past_separator` flips when `--` is met and decides where each argument goes.
2. The stub `summarize` prints `$1: ? hosts`, and `$1` is just the text `web`. The array itself is not visible from the text alone.
3. Add `local -n list=$1` as the first line of the function. `-n` creates a name reference: `list` becomes an alias for the variable called `web` (or `db`, on the second call). `local` keeps the alias private to the function.
4. Use `list` as if it were the array. `${#list[@]}` is the count, `${list[0]}` the first element, `${list[-1]}` the last.
5. Handle the empty array separately: with zero elements, `${list[-1]}` would be an error, so print `<name>: 0 hosts` and stop.
6. Call with the bare name: `summarize web`. If you wrote `summarize "${web[@]}"`, the function would get every host as a separate argument.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
web=()
db=()
past_separator=0
for arg in "$@"; do
  if [[ $arg == -- ]]; then
    past_separator=1
  elif (( past_separator )); then
    db+=("$arg")
  else
    web+=("$arg")
  fi
done

summarize() {
  local -n list=$1
  if (( ${#list[@]} == 0 )); then
    echo "$1: 0 hosts"
  else
    echo "$1: ${#list[@]} hosts (first=${list[0]}, last=${list[-1]})"
  fi
}

summarize web
summarize db
```

## Trying it by hand
`bash solution.sh a b -- c` prints two lines. Then temporarily rename the reference to `web` (`local -n web=$1`) and see the "circular name reference" warning.

## An alternative
Pass the elements and rebuild the array inside the function: `summarize web "${web[@]}"` with `local name=$1; shift; local list=("$@")`. That works, but it copies the array, cannot change the caller's array, and loses the information about where one list ends when you pass two.
