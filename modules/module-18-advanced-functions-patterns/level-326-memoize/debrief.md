# Debrief: Memoize

Memoization trades memory for time. The function is *pure* in spirit: the same
argument always gives the same answer, so computing it twice is waste. An
associative array is the perfect notebook: constant-time lookup, any text as
key.

## Under the hood

Two details carry the level. First, **existence is not the same as
non-empty**. `${cache[$k]+x}` asks "does the key exist?", so even an empty or
"unknown" answer is remembered. Second, **subshells copy the state**. A
command substitution, a pipeline, a `( )` group all run in a copy of the
shell; anything they assign dies with them. Cache writes must happen in the
shell that will read them later, which is why the result travels in a
global variable (`registrar`) rather than on stdout.

## Where it breaks

A cache never expires. That is fine for a one-minute run. For data that
changes (a service status, a price) you would store a timestamp next to the
value and treat old entries as misses. And remember that a script's cache dies
with the script; if you want it to outlive the run, write it to a file.

## In real work

Slow lookups are everywhere in shell scripts: DNS, `whois`, API calls,
`git rev-parse`. Memoizing the per-customer or per-host lookup often cuts a
nightly report from minutes to seconds.

## Going further

Sometimes you need many functions that differ only in a detail. Next: a
function that builds other functions.
