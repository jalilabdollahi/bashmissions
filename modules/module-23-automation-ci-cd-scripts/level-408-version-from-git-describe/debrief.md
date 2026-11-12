# Debrief: Version from git describe

The mental model: **let the source of truth produce the value.** A VERSION file
can be wrong; the tag history cannot. `git describe` compresses "where am I
relative to the last release" into one string, and a build script's job is to
unpack and re-label it.

The parsing lesson is general: when a string has free-form text at the front and
a rigid shape at the back, anchor on the rigid part. A greedy `(.+)` followed by
`-N-g<hash>` makes the regex backtrack to the right split, so hyphenated tags
need no special case. Splitting on a delimiter would have worked on every
test but the one that matters.

Notice also that the version encodes *how trustworthy a build is*. `1.4.0` is a
release. `1.4.0-dev.12+g3f2a1bc` says twelve commits past it, and
`.dirty` says someone built with uncommitted edits. Support (and Noor) can read
that footer and know exactly which source produced a binary.

`if out=$(cmd); then ... else ... fi` is the reusable pattern for "use the
output if it worked, have a fallback if it did not".

Going further: a version now names a build. Next you will generate whole sets of
builds, one per operating system and runtime version.
