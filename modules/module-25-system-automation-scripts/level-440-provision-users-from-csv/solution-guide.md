# Walkthrough: Provision Users from CSV

## The plan

Provisioning is a loop with gates. Each CSV row is turned into fields, checked
for a valid name, checked against existing accounts, and only then handed to
`useradd`. Every outcome is counted so the last line tells the story, and no
single bad row may end the run.

## Building it

Open the file with `done < "$csv"` and read with `IFS=, read -r user fullname
group shell`. Setting `IFS` only for the `read` keeps the rest of the script
unaffected. The fourth variable takes everything left, so it may hold a `\r`
from a file saved on Windows; strip it with `${shell%$'\r'}`.

Keep a `lineno` counter. Line 1 is the header, so `continue` on it. Skip
empty `user` values.

Validate with `[[ $user =~ ^[a-z][a-z0-9_-]{2,15}$ ]]`. The regex is the
policy: lowercase start, 3 to 16 characters, nothing that could be shell
syntax. Bad names go to stderr with the line number and are counted as failed.

Existence check: `grep -q "^$user:" fixtures/etc/passwd`. The colon matters:
without it, `ann` would match `anna`. Existing users are skipped, which makes
the whole script safe to run twice (idempotent).

Call `useradd` inside an `if`. Under `set -e` a bare failing command ends the
script; as an `if` condition it is simply a result you can react to.

Finish with the summary and make the exit status `(( failed == 0 ))`.

## Complete solution

See answer.sh.

## Trying it by hand

```
printf 'username,fullname,group,shell\nlena,Lena Voss,staff,/bin/bash\n' > t.csv
./solution.sh t.csv
cat .calls.log
```

## Alternative

You can prefilter the CSV with `awk -F,`, but then validation, counting and
line numbers all live in awk and are harder to follow than a plain loop.
