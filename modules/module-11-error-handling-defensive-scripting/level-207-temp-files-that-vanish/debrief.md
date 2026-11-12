# Debrief: Temp Files That Vanish

Scratch files fail in two ways, and each has its own cure. A fixed name is a
shared resource: two runs, or a run and an attacker who guessed the name, can
interfere. `mktemp` fixes that by creating the file atomically under a unique
name and handing you the path. You never choose the name; you hold the path in a
variable.

The second failure is forgetting. Cleanup at the bottom of a script is skipped by
any early exit, a failed command under `set -e`, or a signal. `trap ... EXIT`
turns cleanup into a declaration instead of a step: "this file dies when I do".
Combined, the two lines (`tmp=$(mktemp "${TMPDIR:-/tmp}/x.XXXXXX")` and `trap 'rm -f "$tmp"' EXIT`) are the
standard opening of a script that needs scratch space, and worth memorising as a
pair.

Order matters: the trap goes right after creating the file. Quote carefully, as
you learned: single quotes read `$tmp` at exit time; if a later step reassigns
the variable, the trap sees the new value.

On a real server this prevents the slow leak of orphaned temp files, and
the nastier incidents: sensitive data lingering in a world-readable folder, or two
cron jobs corrupting each other's intermediate results.

Going further: scripts that end in many different ways also need to tell the
caller *why*. The next level gives each kind of failure its own exit code.
