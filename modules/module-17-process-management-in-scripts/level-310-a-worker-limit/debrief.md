# Debrief: A Worker Limit

## What you learned

Parallelism needs a brake. Unlimited background jobs can exhaust memory, file
descriptors or a remote server's patience. The pattern is a **bounded
pool**: a counter, a full-check before every start, and `wait -n` to block
until a seat frees up.

## Under the hood

`wait PID` asks about one child; `wait -n` asks about *any* child and returns
as soon as the first one has ended, with that job's exit status. The shell
does not tell you *which* PID it was (newer bash can store it with
`wait -n -p var`), but for a pool you do not need to know: you only need to
know that one seat is free.

The counter is plain bookkeeping in your script. The shell does not enforce
the limit; your `while (( running >= max ))` does. If you forget a `reap_one`
path, the counter drifts and the pool either stalls or overfills.

Batch-and-wait wastes time because the slowest job of each batch gates the
rest. A refilling pool keeps the machine as busy as the limit allows.

## In real work

Image conversion, API calls with rate limits, parallel deploys to a few hosts
at a time: all of them want "N at once, no more". Bash 4.3 or newer is
required for `wait -n`; remember that when targeting very old systems.

## Going further

Next you will look at how background work shares (or does not share) the
shell's variables and working directory: subshells.
