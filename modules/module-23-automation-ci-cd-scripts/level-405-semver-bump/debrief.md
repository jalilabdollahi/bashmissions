# Debrief: Semver Bump

The mental model: **a version is a structured value, not text.** Treat it as
text and you get the 1.9.10 / 1.10.0 mix-ups that sort wrongly and break
dependency resolvers. Parse it into integers, change one, and format it back.

The rules encode a promise to users. Patch means "bug fixes only", minor
means "new features, nothing broke", major means "you may need to change your
code". Resetting the lower numbers on every bump keeps each release number
unique and ordered, so `2.0.0` comes after `1.99.99`.

Strictness is a tool. A regex that rejects `1.2`, `01.2.3` and a pre-release
tag stops a typo from reaching a tag or a package registry, where mistakes are
hard to undo. The no-leading-zero rule also protects the arithmetic: Bash reads
`08` inside `$(( ))` as invalid octal, so the validated form never contains
one.

You will meet the same grammar in `npm version`, Cargo, Go modules and Docker
tags. Tools that bump versions after reading the commit history (changelog
generators, release bots) all end up with a function like this one.

Going further: the bump has to be decided by something. The next level reads
commit messages and groups them into a changelog, the input for that decision.
