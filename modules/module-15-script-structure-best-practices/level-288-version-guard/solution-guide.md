# Walkthrough: Version Guard

## The plan
Three phases, in this order: validate the argument, split it into numbers, compare it
with the running bash. Failing early with a readable message is the whole point of a
guard.

## Steps
1. **Validate and split in one go** with a regex that has capture groups. Group 1 is
   the major number; group 3 is the optional minor (the `(\.([0-9]+))?` part):
   ```bash
   if ! [[ $need =~ ^([0-9]+)(\.([0-9]+))?$ ]]; then
     echo "usage: solution.sh MINVERSION" >&2; exit 2
   fi
   need_major=${BASH_REMATCH[1]}
   need_minor=${BASH_REMATCH[3]:-0}
   ```
   `4.4.1` fails the regex (nothing may follow the minor), as does `five`.
2. **Read the running version** from the array: `${BASH_VERSINFO[0]}` is the major,
   `${BASH_VERSINFO[1]}` the minor. They are separate numbers, so no string parsing.
3. **Compare numerically**: newer major wins; equal major needs a minor at least as
   large:
   ```bash
   (( have_major > need_major )) || (( have_major == need_major && have_minor >= need_minor ))
   ```
   `10#` in front of the variables forces decimal, so `08` is not read as invalid octal.
4. Print the OK line, or the error on stderr with exit status 1.

## Try it
```
./solution.sh 4.4
./solution.sh 5
./solution.sh 99; echo $?
```

## Alternative
Comparing `$BASH_VERSION` as a string, or sorting two version strings with `sort -V`,
is fragile or not portable (`sort -V` is missing on older systems). The numeric array
is available in every bash that has an array at all.
