# Walkthrough: Account Audit

## The plan

Audit scripts of this kind read the data once, classify every record, and keep
the findings in separate lists. Only at the end do they print, in the order the
report requires. That separation is what makes a fixed order possible even though
the checks all happen in the same loop.

## Building it

Load SHADOW first into an associative array, `hash[$name]=$pw`, using `IFS=:
read -r name pw _`. We need two facts per account later: does an entry exist,
and is its hash empty. `${hash[$name]+set}` answers the first without being
fooled by an empty value, and `-z ${hash[$name]}` answers the second.

Read PASSWD line by line. Skip blanks and comments. To detect malformed lines
without caring about what is inside the fields, remove everything except colons
(`${line//[^:]/}`) and check the length: exactly six colons means seven fields.
Malformed lines are recorded and skipped, so they do not count as accounts.

Split a good line with `IFS=: read -r name _ uid _ _ _ shell <<< "$line"`.
Then run the checks. Extra root is `uid == 0` and a name other than root. For the
duplicate check keep `uid_names[$uid]` as a space-joined list plus an array
that remembers the order in which UIDs first appeared. For the service account
check use a `case` on `${shell##*/}`. For passwords, consult the shadow table.

Print with a loop over the list names. A bash nameref (`declare -n list=$group`)
lets one loop print all six lists; `unset -n` releases it for the next
iteration. Count the printed lines as findings.

## Complete solution

See answer.sh.

## Trying it by hand

```
printf 'root:x:0:0::/root:/bin/bash\nbad:x:0:0::/x:/bin/sh\n' > p
printf 'root:$6$a::::::\n' > s
./solution.sh p s
```

## Alternative

One awk program with `NR == FNR` to read both files can do this too. The Bash
version is easier to extend with a new check: add one list and one condition.
