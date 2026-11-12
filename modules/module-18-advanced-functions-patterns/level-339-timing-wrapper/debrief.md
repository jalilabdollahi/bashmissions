# Debrief: Timing Wrapper

A timing wrapper is the same shape as every wrapper in this module: do
something before, run `"$@"`, do something after, give back the original
status. What it adds is the idea of *measuring without touching*: no command
needs to know it is being timed.

## Under the hood

`EPOCHREALTIME` is a special variable: Bash computes its value each time
you read it, so two reads in a row give two different numbers. Its text form
has a decimal separator that depends on the locale (a dot in `C`, sometimes a
comma elsewhere); stripping it is what lets you do integer math, because Bash
arithmetic has no decimals. Everything stays in whole microseconds until the
last moment, when `printf` places the decimal point with `%d.%03d`. That
is the standard trick for decimals in a language without floats.

`SECONDS` is the simpler tool and it has its place: it counts whole seconds
and you can even assign to it (`SECONDS=0`) to restart a coarse stopwatch. For
timeouts and "this took 40 minutes" messages it is plenty.

## Design notes

Measuring a failing command matters most: slow failures are the ones that
hurt. That is why the status is stored and the report printed before returning.
Output goes to stderr, never into the command's stdout, so you can wrap a
command inside a pipeline without corrupting the data.

## Testing time

The tests check the *shape* of the number and a range, never an exact value.
A test asserting `took 1.002s` would fail on a busy machine.

## In real work

Timing slow steps in deploy scripts, spotting the one slow query in a
report, writing durations to a log or metrics endpoint.

## Going further

One more wrapper to build: not how long, but *who ran what*. Next, an audit
wrapper.
