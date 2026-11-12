# Debrief: Tag a Release

The mental model: **check everything that can be checked, then do the one
irreversible thing, then handle the failure you cannot check in advance.** The
two guards cost milliseconds and prevent the two classic release accidents:
tagging a state nobody committed, and re-using a version number.

Git offers two interfaces to scripts. Some commands return data on stdout
(`status --porcelain`), and some answer only with their exit code
(`rev-parse --verify`, `diff --quiet`, `merge-base --is-ancestor`). Knowing
which kind you are holding decides whether you wrap it in `$( )` or put it
straight in an `if`.

The final `push` is different in kind: it depends on the outside world, so it
can fail after your guards passed. The right response is not to hide the failure
but to leave the system in a state the operator can understand, and to tell
them the exact command that repairs it.

You will see this guard-then-act shape in `npm version`, `cargo release` and
every hand-rolled `release.sh`. In CI the tag is usually what triggers the
publish job, so a wrong tag is expensive.

Going further: a tag is also a source of truth. The next level reads it back
with `git describe` to stamp every build with its exact version.
