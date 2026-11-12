# Common Mistakes

- **Shifting before saving.** `shift; environment=$1` stores the first *server*.
  Right: `environment=$1` first, then `shift`.
- **Subtracting after the shift.** `echo "targets=$(( $# - 1 ))"` after a shift
  undercounts by one: the environment is already gone from `$#`.
- **Thinking shift returns the removed value.** `env=$(shift)` runs in a
  subshell and prints nothing useful. `shift` has no output.
- **Shifting an empty list.** `./solution.sh` with no arguments and then
  `shift` fails with `shift count out of range`. Count first when arguments are
  optional.
