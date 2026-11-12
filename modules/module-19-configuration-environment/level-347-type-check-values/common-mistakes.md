# Common Mistakes

- **Doing arithmetic on unchecked text.** Wrong: `(( workers >= 1 ))` with `workers='$((2+2))'` or a variable name evaluates it. Right: match `^[0-9]+$` first, and only then calculate.
- **Forgetting `10#`.** Wrong: `workers=08` makes `(( workers > 0 ))` fail with "value too great for base". Right: `(( 10#$workers > 0 ))`.
- **Case-sensitive booleans.** Wrong: `[[ $debug == true ]]` treats `True`, `YES` and `1` as false. Right: `case ${debug,,} in true|yes|on|1) ...`.
- **Letting an empty value pass.** Wrong: `[[ $debug != @(false|no|off|0) ]]` makes empty and garbage "true". Right: list the accepted words and send everything else, empty included, to `*)`.
- **Stopping at the first error.** Wrong: `exit 1` inside the first failing check hides the other two. Right: count errors, report each, then decide once.
