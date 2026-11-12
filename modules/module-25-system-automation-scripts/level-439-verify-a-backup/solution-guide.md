# Walkthrough: Verify a Backup

## The plan

Two lists must agree: what the manifest says should exist, and what is on the
disk. Walk the manifest and classify every entry, then walk the disk and find
what the manifest forgot.

## Building it

The manifest format is exactly what `cksum file` prints plus the file name:
`CRC SIZE NAME`. That makes parsing trivial: `while read -r crc size name`.
The last variable swallows the remainder of the line, so a name with a space in
it still arrives whole.

For each entry there are three outcomes. Missing is a `-f` test. Otherwise run
`cksum < "$dir/$name"`; reading stdin, cksum prints only `CRC SIZE`, so the
comparison against `"$crc $size"` is one string test. Comparing the size too
catches the rare truncated file whose CRC happens to collide.

Remember every name you saw, for example in a string `listed+="$name "`. After
the manifest loop, glob `"$dir"/*`, skip `MANIFEST` and non-files, and report
any name that is not in the string as UNLISTED. Globs come back sorted, which is
the order the objective asks for.

The exit status can be the final command: `(( failed == 0 && missing == 0 ))`
succeeds only when nothing is wrong, and with `set -e` that line is allowed to
be false at the very end because the script is finished.

## Complete solution

See answer.sh: usage, manifest guard, counters, manifest loop, unlisted loop,
summary, status.

## Trying it by hand

```
mkdir bk; echo alpha > bk/orders.sql
cksum bk/orders.sql | sed 's|bk/||' > bk/MANIFEST
./solution.sh bk
echo tamper >> bk/orders.sql; ./solution.sh bk
```

## Alternative

An associative array (`declare -A seen`) is the tidier way to remember names;
the string version works on any Bash and is enough for a few hundred files.
