# Walkthrough: Offboard a User

## The plan

Offboarding is a short, strictly ordered procedure with one hard rule up
front: never act on an account that is not an ordinary person. So the script
validates first, locks second, archives third, reports last.

## Building it

Handle the optional `-n` the usual way: look at `${1:-}`, set `dry=1`, shift.
Then there must be exactly USER and STAMP.

Look the user up with awk: `awk -F: -v u="$user" '$1 == u { print $3 }'`.
Comparing the first field with `==` avoids the prefix problem that `grep`
patterns have (`ann` versus `anna`). An empty answer means the user is unknown.
A UID below 1000 means root or a service account; refuse with status 3. These
two checks come before the dry-run branch, so even a dry run warns you.

The dry-run branch prints the two "would" lines and exits 0. Because it comes
before any command with side effects, nothing can slip through.

The real work: `usermod -L -s /usr/sbin/nologin "$user"` locks the password
and removes the shell in one call. Then, if the home folder exists, create
`offboarded/`, archive it with `tar -czf "$archive" -C fixtures/home "$user"`
and count the regular files by listing the archive. No home directory simply
means `archive: none` and `files: 0`.

## Complete solution

See answer.sh.

## Trying it by hand

```
mkdir -p fixtures/home/kit && echo hi > fixtures/home/kit/a.txt
./solution.sh -n kit 20260301
./solution.sh kit 20260301; cat .calls.log
```

## Alternative

Archiving first and locking second feels natural but leaves a window in which
the user could still write to the files you are copying. Lock first.
