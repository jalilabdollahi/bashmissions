# Common Mistakes

- **Not resetting per-rule variables.** awk variables keep their values from the previous line, so a rule without `-s` inherits the source of the one before it.
  - Right: set `src = ""; ports = ""; ...` at the top of each rule.
- **Reading the wrong option word.** `$2 == "-s"` only works when `-s` happens to be the second field; options appear in any order.
  - Right: loop over the fields and look at `$(i + 1)`.
- **Ignoring multiport.** `--dport 22` is not the only syntax; `-m multiport --dports 80,22` hides port 22 in a list.
  - Right: `split(ports, p, ",")` and test each element.
- **Counting rules of other chains as findings.** A FORWARD rule for port 22 is a different question.
  - Right: match `/^-A INPUT /` only (but count all `-A` lines in the total).
- **Checking `-j ACCEPT` loosely.** A `-j DROP` rule for port 22 is protecting you.
  - Right: require the target to be ACCEPT.
