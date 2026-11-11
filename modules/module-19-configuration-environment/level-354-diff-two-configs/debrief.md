# Debrief: Diff Two Configs

The mental model: **compare meaning, not bytes.** A config file is a mapping from
names to values; how it is laid out (order, indentation, comments) is presentation.
A tool that compares presentation produces noise, and noise hides the one line that
matters. Parse first, normalise, then compare the normalised data. This is the idea
behind `git diff --word-diff`, semantic JSON diffs, `terraform plan` and
`kubectl diff`.

The set view gives three outcomes for every name, and the code mirrors them: only in
the new file (added), only in the old (removed), in both with different values
(changed). The edge that decides correctness is the difference between "absent" and
"empty". `${table[$key]+set}` is the test that tells them apart, and it is why
`motd=` turning into a change rather than a removal worked here.

The exit status is part of the interface. Following `diff`'s convention, 0 means
"same" and 1 means "different", so the script drops straight into a pipeline:
`if ! compare old new; then page_someone; fi`. A sorted report plus a one-line summary
serves both readers: a human skimming during an incident, and a script that counts.

Under the hood, `local -n` (a nameref, Bash 4.3+) lets a function work on a variable
by name without `eval`, the safe way to share one parser between two arrays.

Going further: that is the end of the Configuration module. Defaults, files,
environment, flags, secrets, reloads, migrations and diffs are the skeleton of every
configurable tool. The next module is about running those tools safely: security.
