# Walkthrough: Firewall Rule Audit

## The plan

Treat each rule line as a tiny record. Parse it once into named facts, source,
interface, protocol, module use, ports and target, and then the audit rules
become short boolean expressions over those facts. awk is made for this: it
splits every line into fields and keeps the line number in `NR`.

## Building it

Guard the input first: a readable file that contains a `*filter` line. That
second check turns "someone passed the wrong file" into a clear message
instead of a silent report of zero findings.

The awk program has three kinds of pattern. `/^:INPUT /` matches the chain
policy line (`:INPUT ACCEPT [0:0]`), whose second field is the policy.
`/^-A /` counts every rule of every chain, for the final tally. `/^-A INPUT /`
is the interesting one.

For an INPUT rule, reset the variables and loop over the fields from 2.
Options are word pairs, so `if ($i == "-s") src = $(i + 1)` picks the value
that follows. `-m` just records that some module is used. A rule is "open to
the world" when it has no `-s` or `-s 0.0.0.0/0`, and it matters only when
its target is ACCEPT.

For world-open ACCEPT rules: if ports are given, `split(ports, p, ",")`
handles both `--dport 22` and a multiport list. An element with a colon is a
range; otherwise compare it with the four sensitive ports. With no ports, no
interface, no protocol and no module, the rule accepts everything.

`END` prints the tally and `exit (found > 0)` gives awk's exit status, which
the shell passes on because awk is the last command.

## Complete solution

See answer.sh.

## Trying it by hand

```
./solution.sh fixtures/sample-rules.txt
```

Copy the file and add `-A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT` to see a finding.

## Alternative

A `while read` loop with `case` patterns works, but option pairs are awkward
to pick out with shell word splitting; awk's `$(i + 1)` is much simpler.
