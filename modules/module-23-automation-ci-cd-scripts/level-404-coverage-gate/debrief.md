# Debrief: Coverage Gate

The mental model: **a quality gate is a comparison you can defend.** When the
build goes red at 79.96% and the developer says "but it prints 80.0%", the
script has to be right and also explainable. Deciding on the exact fraction
and displaying a rounded copy gives you both.

Shell arithmetic is integer-only. That is a feature once you know the two
standard moves: scale before you divide (tenths of a percent), and compare
fractions by cross-multiplying instead of dividing at all. Both keep the maths
exact, and both work in any POSIX shell.

Validation order matters too. Inside `$(( ))` an unknown word is treated as a
variable and silently becomes 0, and a leading zero means octal, so
`$(( 08 ))` is an error. Matching `^[0-9]+$` first, and writing `10#$n` where
leading zeros are possible, closes both holes.

You will see exactly this in `pytest --cov-fail-under`, `go test -cover` gates
in CI, and Sonar quality gates. Gus will also love it: one line that says
PASS or FAIL.

Going further: a threshold needs a version to attach to. The next level does
arithmetic on something every release has, a version number, and bumps it.
