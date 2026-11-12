# Common Mistakes

- **Mixing up the order.** The sentence says plan last, but `$2` is still the
  plan. Wrong: `echo "$1 -> $2 seats on the $3 plan"`. Right: seats is `$3`.
- **Forgetting to quote a multi-word value.** `./solution.sh North Pier Dental
  harbour 12` shifts everything by two. Write `"North Pier Dental"`.
- **Using `$10` for the tenth argument.** `$10` means `$1` then a literal `0`.
  Right: `${10}`.
- **Expecting a missing argument to be an empty string.** With `set -u`, reading
  `$3` when only two were given stops the script with `unbound variable`.
