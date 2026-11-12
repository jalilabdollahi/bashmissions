# Walkthrough: The Chaos Monkey

## The plan
Chaos engineering is controlled sabotage: break a piece of production on purpose, watch whether the system copes, repair it. The danger of chaos is that it is unrepeatable, and so it cannot be debugged. The cure is **determinism**: derive every random choice from a seed, and the same seed replays the same sequence of faults. A teammate can say "seed 42, round 5" and everyone sees the same failure.

Bash's `$RANDOM` can be seeded (`RANDOM=42`) but the sequence it produces changed between Bash versions, so a seed on one laptop is not a seed on another. The fix is to own the generator. A linear congruential generator (LCG) is the oldest and smallest: `state = state * a + c` modulo some power of two. With the classic constants `a = 1103515245`, `c = 12345` and a modulus of 2^31 it fits in Bash's 64-bit integers without overflow.

## Step by step

1. **Parse and validate** the arguments with regexes, the optional `--dry-run` flag first. Failures print one usage line and exit 2, so a typo never starts a destructive run.

2. **Select targets.** Read the fleet file, skip comments, skip `protected` services, keep the rest in order. An empty target list ends the run with a message: a monkey with nothing to break must say so, not divide by zero in `rnd % 0`.

3. **The generator.** `next()` updates the global `state` and sets `rnd = state >> 16`. Low bits of an LCG are poorly random (the lowest bit simply alternates), so we use the high bits. It must be a function that changes globals, not something called inside `$(...)`: command substitution runs in a subshell and would throw the new state away.

4. **Draw in a fixed order.** Roll for "does anything happen", then target, kind and parameter. The specification fixes the order and even says the parameter is drawn for `kill` where it is not needed. Skipping that draw would make `kill` rounds shift every later round. This is the heart of reproducibility: the *sequence of draws* is part of the interface.

5. **Act.** Dry run prints a plan and calls nothing. A live round injects, observes, heals and observes again. The observations are what turn vandalism into an experiment: S1 proves the fault took effect, S2 proves the repair worked. Any service still unhealthy is counted and the run ends with a failing status.

## Complete solution
```bash
state=$((seed & 2147483647))
next() {
  state=$(( (state * 1103515245 + 12345) & 2147483647 ))
  rnd=$(( state >> 16 ))
}
```
The loop around it is in `answer.sh` once you pass.

## Try it by hand
```bash
./solution.sh --dry-run 42 8 fixtures/fleet.txt
./solution.sh --dry-run 42 8 fixtures/fleet.txt | cksum   # identical every time
./solution.sh 42 8 fixtures/fleet.txt; cat .calls.log
```

## Alternative
`RANDOM=$seed` then `$RANDOM % n` is shorter, and fine for a single machine. You give up portability of the seed and the ability to document the sequence in a specification. For tests, documentation and "replay this incident", the explicit LCG wins.
