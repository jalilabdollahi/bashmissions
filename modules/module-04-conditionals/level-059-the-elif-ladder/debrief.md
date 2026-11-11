# Debrief: The elif Ladder

A ladder is a decision with more than two outcomes. The important idea is
order: Bash walks down from the top and stops at the first true test. Everything
below it is never even evaluated. Because of that, the order of your rungs is
part of the logic, and the closing `else` acts as a safety net for values you
did not plan for.

## Under the hood

An `elif` is not magic. It is literally `else` followed by a nested `if`, written
flat so you do not drown in indentation. Each test is an ordinary command whose
exit status is checked, exactly as in the previous levels. Only the first command
that succeeds gets its body executed.

## Where it shows up

Status-code handling, severity levels (info, warning, critical), and install
scripts that choose between several package managers all use ladders. The
catch-all branch is what separates a script that handles surprises from one that
silently does nothing when a new code appears.

## Going further

You compared codes as strings, which worked because the codes are fixed words.
Soon you will compare real numbers ("is the disk above 90 percent?"), and that
needs different operators.
