# Walkthrough: The Incident Responder

## The plan
Evidence has to be collected at the moment of the problem, automatically, and without making
things worse. That gives the design its three constraints: be quiet when nothing is wrong, do not
repeat yourself while an alarm keeps ringing (cooldown), and never leave half a snapshot that
someone may mistake for the real thing (build in a temp directory, then `mv`). A final
retention rule keeps the disk from filling up with the very evidence you collect.

## Step by step
1. **Options and clock.** `--cooldown` and `--keep` are validated as integers. `now=${NOW:-$(date +%s)}`
   makes the clock injectable: tests, and you at the terminal, can replay a situation at a chosen
   second. `date +%s` is not in POSIX but both macOS and Linux support it.

2. **Validate all rules first.** A loop over the rules file checks field count, operator (a `case`
   with quoted patterns, because `>` and `<` are shell syntax), the threshold with a numeric regex,
   and each collector. Doing this before any evaluation means a typo on line 7 can never leave you with
   three snapshots taken and a fourth rule broken.

3. **Numbers in Bash.** `(( ))` only handles integers, but metrics like load average are decimals.
   `breached VALUE OP THRESHOLD` delegates to awk, which compares as numbers (`v + 0` forces
   numeric context) and reports through its exit status: `exit !r`.

4. **Per rule.** Missing or non-numeric samples are reported as "no data" (a broken sensor is
   not a breach). Otherwise either `ok`, or a breach. A breach consults `incidents/.last/NAME`: if the
   rule fired less than `cooldown` seconds ago, say how long remains and stop.

5. **The snapshot.** `mktemp -d incidents/.tmp-XXXXXX` creates the work area on the same filesystem as the
   destination, so the final `mv` is an atomic rename. The trap removes `$tmp` unless it has been
   cleared after the move. Each collector is one `case` arm; a failing one must not abort the
   others, so the loop tests it with `if ! collect ...`, writes `collector failed` to its file
   and carries on, because partial evidence beats none.

6. **Bookkeeping.** The sequence file, the cooldown stamp and the INDEX line are written *after* the
   move succeeded. Zero-padded sequence numbers make a plain `sort` order the directories, which
   makes retention easy: list, count, delete the oldest `count - keep`.

7. **Result.** A summary line and exit status 1 if anything breached, so a wrapper can alert.

## Try it by hand
```
NOW=1000000 ./solution.sh rules.conf sample.conf
ls incidents/*
```

## Alternative
Timestamps in snapshot names are friendlier to read than sequence numbers, but they need
`date` formatting that differs between systems and can collide when two rules fire in the same
second. A counter is boring and unambiguous.
