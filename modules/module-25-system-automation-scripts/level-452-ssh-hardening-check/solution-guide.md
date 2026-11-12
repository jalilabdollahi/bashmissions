# Walkthrough: SSH Hardening Check

## The plan

Do not grep the file. Grep answers "does the text appear?" while sshd answers
"which value wins?". The checker therefore first rebuilds sshd's view of the
global settings as a table, and then audits the table.

## Building it

Read the file line by line. Trim leading blanks with a parameter expansion
(`${line#"${line%%[![:space:]]*}"}`), and skip empty lines and comments.
sshd accepts `Key value`, `Key=value` and `Key = value`, so replace every `=`
with a space and let `read -r key value _` split on blanks. Lowercase the key
with `${key,,}`; the value is lowercased when stored.

Two rules shape the table. A `Match` line ends the global section, so `break`.
And only the first occurrence of a keyword counts: store a keyword only if
`${seen[$key]+set}` says it is absent. That expansion tests presence rather
than emptiness, which matters if a value is missing.

For the audit, a `check` function takes the keyword's display name, its default
and the kind of requirement. It looks the value up and notes whether it fell
back to the default, then compares: `no` for four of them, "a whole number up to
4" for MaxAuthTries (check the digits with a regex before the arithmetic so
`many` cannot crash `(( ))`). The text suffix depends on two facts, default or
explicit, pass or fail, and is assembled accordingly.

Count failures in a variable and print the summary; exit 1 if any failed.

## Complete solution

See answer.sh.

## Trying it by hand

```
./solution.sh fixtures/sshd_config.sample
```

Move `PermitRootLogin no` above the existing line and rerun.

## Alternative

`sshd -T` prints the effective configuration directly on a real server. This
checker works on a copy of the file, for example from a backup or another host.
