# Walkthrough: Compliance Report

## The plan

A compliance report is a scorecard: a fixed list of controls, a verdict for
each control on each host, and totals. The way to keep that readable in code is
to make each control its own function and let a single loop do the asking.

## Building it

Options first. `getopts "fm:"` declares `-f` as a flag and `-m` as an option
with an argument (the colon). After the loop `shift $((OPTIND - 1))` removes
the parsed options and leaves the folder as the first positional argument.
Validate `-m` as a whole number up to 100 before anything else, since a wrong
option is a usage error (status 2).

Each check is a function that takes the host folder and succeeds or fails; its
exit status is the answer, which makes `if check_disk "$dir"; then` read like
English. Missing evidence is a failure, except for the reboot check, which asks
for an absence.

The root login check needs the first `PermitRootLogin` line, whatever its
capitalisation: awk's `tolower($1) == "permitrootlogin"` prints the lowercased
value of the first match and exits. The disk check uses awk too: skip the header
with `NR > 1`, and note that `$5 + 0` converts `91%` to the number 91; `exit
!bad` returns success when any filesystem is at or above 90, so the function
negates that.

Two arrays hold the check names and the function names, in matching order.
For each host collect PASS/FAIL results, print the header with the host's score,
then the lines, skipping PASS lines when `-f` is set. Sum the scores.

At the end the percentage is integer arithmetic, `passed * 100 / total`, and the
verdict compares it with the minimum. Rounding down means 99.9% does not
secretly pass a 100% requirement.

## Complete solution

See answer.sh.

## Trying it by hand

```
mkdir -p hosts/eel; echo "PermitRootLogin no" > hosts/eel/sshd_config
./solution.sh -f hosts
```

## Alternative

A table-driven approach with one `case` per check works, but separate
functions are easier to test on their own and to extend with check number five.
