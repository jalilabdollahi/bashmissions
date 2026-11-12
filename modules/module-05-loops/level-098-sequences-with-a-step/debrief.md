# Debrief: Sequences with a Step

Counting by ones is the easy case. Real schedules count by fives, by fifteens, by a week. `seq FIRST STEP LAST` is the compact way to ask for such a sequence when the numbers come from variables.

## How it works
`seq` is an ordinary command that prints numbers, one per line. In a `for` loop with `$(seq ...)`, the shell substitutes the output and splits it into words, which is exactly what you want for plain numbers. Both ends are inclusive: `seq 0 15 45` stops at 45, but `seq 0 20 45` stops at 40 because 60 would overshoot.

Watch the empty case. If the direction and the limit disagree (step up, but the last value is below the first), GNU `seq` prints nothing while BSD `seq` on macOS prints an error. Scripts that must run on both should test for "nothing to do" before calling `seq`. A negative step with a lower end gives a countdown: `seq 10 -2 0`.

Brace ranges can also take a step (`{0..45..15}`), but their ends must be written literally. When the end is in a variable, you need `seq` or a C-style loop. Zero as a step is an error, so validate user input first.

Converting minutes to a clock face is a small recipe worth remembering: divide for the hours, take the remainder for the minutes, pad with `%02d`.

## In real work
Cron-like schedules, port ranges in steps, test data, pagination offsets.

## Going further
The final stretch: searching a list and stopping at the first hit, then running things in parallel.
