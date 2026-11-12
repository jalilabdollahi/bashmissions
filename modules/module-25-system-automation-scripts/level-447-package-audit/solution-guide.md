# Walkthrough: Package Audit

## The plan

An audit compares two things: a description of what should be true (the
policy) and a snapshot of what is true (the installed packages). Load the
snapshot into a lookup table once, then evaluate each rule against it.

## Building it

`dpkg-query -W -f='${Package} ${Version}\n'` prints `name version` per line.
Read it with `while read -r name version` into `declare -A installed`. Reading
through process substitution keeps the array in the main shell. Single quotes
matter: Bash must not expand `${Package}`; dpkg-query does that itself.

Validate the policy in its own pass: a `case` on the first word of each line
accepts blanks, comments and the three known verbs, and exits with the line
number for anything else. Doing this before printing means a typo cannot
produce half a report.

The rules are then a second `case`. `require` and `forbid` are plain lookups
with `${installed[$name]:-}`. `minver` needs a version comparison. First reduce
`1.9.5p2-3` to its numeric prefix with `[[ $v =~ ^[0-9][0-9.]* ]]`. Then
`older()` splits both strings on dots into arrays and walks the longer one:
at the first position where the numbers differ the verdict is known, and
missing positions count as 0. This is why 3.0.9 is older than 3.0.13, which a
plain string comparison would get backwards. `10#` prevents values such as
`08` from being treated as octal.

Count problems and print `audit: clean` or `audit: N problem(s)`.

## Complete solution

See answer.sh.

## Trying it by hand

```
printf 'require bash\nminver bash 5.0\n' > p.txt
./solution.sh p.txt
```

## Alternative

`sort -V` compares versions in GNU sort, but not on every macOS version.
Splitting on dots is portable and shows exactly how the comparison works.
