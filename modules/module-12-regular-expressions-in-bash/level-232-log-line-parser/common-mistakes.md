# Common Mistakes

- **Miscounting the optional group.** In `(invalid user )?([^ ]+)` the user is group 3
  (group 2 is the optional one), even on lines where `invalid user` is absent.
  Count the opening parentheses from the left.
- **Reading stale groups.** Every `=~` overwrites `BASH_REMATCH`. After the `elif`
  test for Accepted, the groups of the Failed test are gone; read them inside the
  branch that matched.
- **No end anchor.** Without `$`, `... port 3 ssh2 extra` is accepted. A parser
  needs the whole line to fit.
- **Rigid spacing.** `Nov 7` and `Nov  7` (two spaces) both occur. `+` after the
  space, `[A-Z][a-z]{2} +[0-9]{1,2}`, copes with both.
- **Unescaped brackets.** `sshd[2211]` in a regex is a class meaning one of the
  characters `2 1`. Write `sshd\[[0-9]+\]`.
- **Alerting on any login.** The rule is "after 3+ failures". Check the counter at
  the moment of the `Accepted` line, not at the end of the input.
