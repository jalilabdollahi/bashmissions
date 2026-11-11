# Common Mistakes

- **Piping instead of process substitution.** The counters silently stay at their start values.
  Wrong: `fleet-disk | while read -r h p; do over=$((over+1)); done; echo "$over"` prints 0
  Right: `while read -r h p; do ...; done < <(fleet-disk)`
- **Missing the space between the two `<`.** `<<(` is a syntax error, because `<<` means here-document.
  Wrong: `done <<(fleet-disk)`
  Right: `done < <(fleet-disk)`
- **Starting the maximum at 0.** A fleet full of 0% disks never updates the name.
  Right: start below any possible value (-1) and test strictly with `>`
- **Using `>=` for the maximum.** The last server in a tie wins instead of the first.
- **Counting 80 as over 80.** The rule is "more than 80", so use `> 80`.
