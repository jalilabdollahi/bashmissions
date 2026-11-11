# Walkthrough: Division and Remainder

## The plan

A day has 1440 minutes and an hour has 60. We peel the number apart in three
bites: take out the full days, take out the full hours from what remains, and
what is left is the minutes. Each bite uses one of two operators:

| operator | question it answers | `4507` with `1440` |
|---|---|---|
| `/` | how many whole times does it fit? | 3 |
| `%` | what is left after that? | 187 |

## Building it

Days are the easy part:

```bash
days=$(( minutes / 1440 ))
```

For hours we first need the leftover after the days, then divide it by 60.
`%` and `/` have the same strength and run left to right, so this reads
"(minutes % 1440) / 60":

```bash
hours=$(( minutes % 1440 / 60 ))
```

With 4507 minutes: 4507 % 1440 = 187, and 187 / 60 = 3 whole hours.

The leftover minutes: just ask the remainder of the original number divided by
60, since 1440 is a multiple of 60.

```bash
mins=$(( minutes % 60 ))
```

187 minutes is 3 hours and 7 minutes, and indeed 4507 % 60 = 7.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

minutes="$1"
days=$(( minutes / 1440 ))
hours=$(( minutes % 1440 / 60 ))
mins=$(( minutes % 60 ))

echo "uptime: ${days}d ${hours}h ${mins}m"
```

The braces in `${days}d` keep the `d` from being read as part of the name.

## Try it by hand

```bash
./solution.sh 4507
./solution.sh 1439
./solution.sh 263520
```

## An alternative

Repeatedly update one variable: `minutes=$(( minutes % 1440 ))` after reading
the days. That works, but it destroys the original number. Keeping `minutes`
untouched and deriving each part from it is easier to check by eye.
