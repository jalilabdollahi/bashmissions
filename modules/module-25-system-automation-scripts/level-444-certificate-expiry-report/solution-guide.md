# Walkthrough: Certificate Expiry Report

## The plan

Dates are awkward because months differ in length and leap years exist. The
trick is to stop treating a date as three parts and map it to one integer: a
day number. Subtracting two day numbers gives whole days, and every
calendar rule is already inside the formula.

## Building it

Validate TODAY with a regex that captures year, month and day into
`BASH_REMATCH`. Write `daynum()` using the March-based trick: treat January and
February as months 13 and 14 of the previous year, so the leap day is always
the last day of a "year". The expression
`365*y + y/4 - y/100 + y/400 + (153*(m-3)+2)/5 + d` counts days. Its absolute
value is meaningless; only differences matter. Use `10#$2` so a month such as
`08` is read as decimal.

For each certificate, ask openssl for the end date, throwing away its stderr
and testing the status in an `if`, so one broken file does not stop the report.
Remove the `notAfter=` prefix and let `read` split the rest on blanks: that
handles `Mar  4` with its double space. Look up the month number in a little
string (` Jan 1 Feb 2 ...`) with parameter expansion, then subtract.

Rows are accumulated as `days name` lines so `sort -n` can order them (negative
numbers sort correctly with `-n`). Print with the exact `printf` layout, count
anything with 30 days or fewer, and finish with the summary and exit status.

## Complete solution

See answer.sh.

## Trying it by hand

```
mkdir certs; echo 'notAfter=Mar  4 12:00:00 2026 GMT' > certs/demo.pem
./solution.sh 2026-03-01 certs
```

## Alternative

GNU `date -d "$enddate" +%s` does this in one line but fails on macOS. The
integer approach works everywhere and is easy to test.
