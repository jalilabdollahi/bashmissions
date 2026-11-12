# Walkthrough: Validate a Date

## The plan
Three questions, asked in order, each with the tool it suits:

1. Is the text shaped like `YYYY-MM-DD`? (regex)
2. Is the month 1 to 12? (arithmetic)
3. Does that day exist in that month? (arithmetic, with the leap-year rule)

The first failing question decides the message, and `continue` skips the rest.

## 1. The shape
```bash
re='^([0-9]{4})-([0-9]{2})-([0-9]{2})$'
```
`2024-4-5` has one-digit parts, `2024/04/05` has the wrong separator and
`2024-04-05 ` has a trailing space; with the anchors none of them match.

## 2 and 3. The calendar
Right after the match, copy the groups into numbers. `10#` matters: `08` and
`09` are errors in octal.

```bash
year=$(( 10#${BASH_REMATCH[1]} ))
month=$(( 10#${BASH_REMATCH[2]} ))
day=$(( 10#${BASH_REMATCH[3]} ))
```

February is the only month with a rule: a leap year when divisible by 400, or
divisible by 4 but not by 100. That is why 2000 and 2024 are leap years, and
1900 and 2100 are not. A `case` statement maps the month to its maximum day.

## Complete solution
See `answer.sh`: shape check, month check, `case` for the maximum, day check.

## Try it by hand
```bash
printf '2024-02-29\n2023-02-29\n2024-13-01\n2024-4-5\n' | ./solution.sh
```

## Alternative
The `date` command can often tell you whether a date is valid, but its flags
differ between macOS and Linux, and it would hide the reason. Doing it by hand is
portable and lets you give a specific message.
