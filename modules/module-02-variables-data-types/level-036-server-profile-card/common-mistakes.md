# Common Mistakes

- **Printing before validating.**
  Wrong: starting the card and checking `SERVER` halfway - a half-printed card on failure.
  Right: `server=${SERVER:?...}` as the first real line.
- **A greedy grep pattern.**
  Wrong: `grep "$server" fixtures/owners.txt` matches `eel` inside any other line that contains it.
  Right: `grep "^$server:" fixtures/owners.txt`.
- **Declaring after assigning.**
  Wrong: `per_dimm=$ram/$dimms` then `declare -i per_dimm` stores the text `10/4`.
  Right: declare first, then assign.
- **`$server_$role`.** Bash reads `server_` as one name. Write `${server}_${role}`.
