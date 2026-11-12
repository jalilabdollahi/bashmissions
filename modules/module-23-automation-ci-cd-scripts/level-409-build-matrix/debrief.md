# Debrief: Build Matrix

The mental model: **describe the dimensions, let loops generate the cases.**
Hand-written pipelines grow one line per combination and drift apart. A matrix
keeps the data (which systems, which versions) separate from the procedure
(build one), so adding Windows or Python 3.13 is a change to one list.

Nested loops give you the product, and `continue` gives you the exclusion
list that every real matrix needs ("macOS with the oldest runtime is not
supported"). Counting `ran` separately from the number of pairs is the quiet
detail: skipped jobs are neither passes nor failures, and a summary that mixes
them up misleads.

Bash details worth remembering: `IFS=, read -ra` splits on commas for that one
command only; arrays keep items intact so `"${oses[@]}"` is safe; and a
validation regex has to reject empty items itself because `read` swallows them.

This is the same model as GitHub Actions `strategy.matrix`, GitLab
`parallel:matrix` and `tox` environments, all of which expand lists into jobs and
accept `exclude:` entries.

Going further: each matrix job produces a file, and files in a release need
names that say what they are and checksums that prove they arrived intact. That
is the next level.
