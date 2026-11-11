# Debrief: Long Flags by Hand

This is the first time a script of yours has a real grammar. The pattern, "loop
while arguments remain, `case` on the first one, `shift` what you used", is how a
large share of the world's shell tools parse options. Once you can read it, you
can read almost any install script.

Think of three layers. Defaults describe what happens when the user says
nothing. The loop turns what they said into variable values. The code after the
loop validates the combination (is the required flag present?). Keeping those
layers separate keeps parsers easy to extend: a new flag is a new default and a
new branch.

Two rules prevent the classic bugs. Every branch must shift, otherwise the loop
spins forever. And the catch-all `*)` branch must exist, so a mistyped flag is an
error instead of being silently ignored, an invisible typo such as `--dryrun` is
exactly what you want your tool to shout about.

Going further: Bash has a built-in parser for the short, single-letter style
(`-v -n 3`), with less typing. It is the next level.
