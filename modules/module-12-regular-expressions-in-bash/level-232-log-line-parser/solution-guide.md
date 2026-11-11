# Walkthrough: Log Line Parser

## The plan
Parsing a log is three separate jobs, and keeping them apart keeps the script
readable:

1. **Recognise and split** each line with a regex (one per line type).
2. **Remember** facts per IP in associative arrays.
3. **Report** after the input ends.

## 1. Two regexes, shared prefix
Every line starts the same way: `Nov  7 09:30:15 anchovy sshd[2211]: `.

| piece | regex |
|---|---|
| month and day | `[A-Z][a-z]{2} +[0-9]{1,2}` (the day may be padded with spaces) |
| time | `([0-9]{2}:[0-9]{2}:[0-9]{2})` group 1 |
| host and process | `[^ ]+ sshd\[[0-9]+\]:` (brackets escaped) |

Failed lines: `Failed password for (invalid user )?([^ ]+) from ([0-9.]+) port [0-9]+ ssh2$`.
Groups: 1 time, 2 the optional "invalid user ", 3 user, 4 IP. When the optional
group did not take part, element 2 is just empty; the others keep their
numbers. Accepted lines: `Accepted (password|publickey) for ([^ ]+) from ([0-9.]+) ...`:
1 time, 2 method, 3 user, 4 IP.

Both end with `$`, so `... ssh2 extra` is rejected.

## 2. Remember
```bash
declare -A failures=() last_user=() last_time=() alert_user=()
failures[$addr]=$(( ${failures[$addr]:-0} + 1 ))
```
`${failures[$addr]:-0}` supplies 0 the first time. An `Accepted` line sets
`alert_user[$addr]` only when the failure count has already reached 3: the order
of events matters, so a login *before* the failures is not an alert.

## 3. Report
Collect the IPs with 3+ failures into an array, sort them with
`printf '%s\n' ... | sort`, and print the `BLOCK` line followed by the `ALERT`
line if there is one. The `if (( ${#offenders[@]} > 0 ))` guard avoids printing an
empty line when nobody qualifies.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
printf 'Nov  7 09:30:15 a sshd[1]: Failed password for root from 10.0.0.9 port 1 ssh2\n' | ./solution.sh
```

## Alternative
`grep -E 'Failed password' | sed ... | sort | uniq -c | awk ...` can produce counts
too, but it cannot tell whether a login happened after the third failure. The
state and ordering live naturally in the Bash loop.
