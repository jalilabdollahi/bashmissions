# Debrief: What set -e Does

`set -e` flips the script's default from "keep going" to "stop at the first
failure". It is a cheap safety net, and Theo's folder-deleting script would have
died on the failing `cd` with it. But it is not magic, and the useful skill is
knowing where it looks the other way.

Bash reasons that a command whose status is being *consumed* is not an
unexpected failure. So errexit is suppressed for the condition of `if`, `while`
and `until`, for commands after `!`, and for every command in an `&&` / `||`
list except the last. A failure in `cmd1 && cmd2` where `cmd1` fails is the
list's normal "no", so the script goes on. The same rule applies to everything
called from inside those conditions, which is why a function used as an `if`
condition silently loses its set -e protection.

This is why professionals combine set -e with explicit checks rather than trusting
it blindly. It catches the line nobody thought could fail; careful `if` tests
handle the statuses that are answers.

Going further: set -e only watches command failures. A mistyped variable name is
not a failure at all, it is silently empty. The next level adds the second half
of the safety net.
