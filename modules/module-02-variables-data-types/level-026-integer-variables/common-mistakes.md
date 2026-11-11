# Common Mistakes

- **Forgetting to declare.**
  Wrong: `total=$WEB+$DB` stores the text `3+2`.
  Right: `declare -i total` first, then `total=$WEB+$DB`.
- **`+=` on a text variable.**
  Wrong: `count=6; count+=2` gives `62`.
  Right: declare the variable with `-i` so `+=` adds.
- **Spaces in the expression.**
  Wrong: `total=$WEB + $DB` runs a command called `+`.
  Right: `total=$WEB+$DB`, or quote the expression: `total="$WEB + $DB"`.
- **Expecting decimals.**
  `declare -i half=5/2` stores `2`. Bash arithmetic is integer-only.
