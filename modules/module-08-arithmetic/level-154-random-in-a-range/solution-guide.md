# Walkthrough: Random in a Range

## The plan

`$RANDOM` gives a number from 0 to 32767. We need one from LOW to HIGH. The
recipe has three parts: count how many values are allowed, reduce `$RANDOM` to
that many possibilities with `%`, and shift the result up by LOW.

## Building it

Seed first. Assigning to `RANDOM` sets the generator's starting point, so the
same seed produces the same sequence. That is what makes a run replayable when
somebody asks about job 17:

```bash
RANDOM="$seed"
```

How many values fit between LOW and HIGH when both are included? For 5 to 45
that is 41, not 40:

```bash
size=$(( high - low + 1 ))
```

`RANDOM % size` lands in `0 .. size-1`. Adding `low` moves that window to
`low .. low+size-1`, which is exactly `low .. high`:

```bash
echo "slot=$(( low + RANDOM % size ))"
```

Negative LOW works with no special treatment, because `RANDOM % size` is never
negative; the shift does the rest.

Repeat COUNT times with a counting loop:

```bash
for (( i = 0; i < count; i++ )); do
  echo "slot=$(( low + RANDOM % size ))"
done
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

seed="$1"; low="$2"; high="$3"; count="$4"

RANDOM="$seed"
size=$(( high - low + 1 ))

for (( i = 0; i < count; i++ )); do
  echo "slot=$(( low + RANDOM % size ))"
done
```

## Try it by hand

```bash
./solution.sh 42 5 45 5
./solution.sh 42 5 45 5     # identical: same seed
./solution.sh 43 5 45 5     # different seed, different numbers
```

## An alternative

`shuf -i 5-45 -n 12` does the same job in one command, but it is not available
everywhere (macOS lacks it by default), and it cannot be seeded as simply. For
a tiny range inside a script, `$RANDOM` is the dependable choice.
