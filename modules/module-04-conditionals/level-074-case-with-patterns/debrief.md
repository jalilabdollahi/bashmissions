# Debrief: case with Patterns

`case` is a pattern matcher with a body attached to each pattern. Two features
turn it from a menu into a tool: wildcards in the patterns and `|` for
alternatives. Together they let one branch describe an entire family of inputs
such as "any zip", "tgz or tar.gz", or "anything starting with `web-`".

## Under the hood

Branches are tested from top to bottom with glob matching, and the first match
wins; the rest are skipped. Because of that, the order of branches is part of the
program. The rule of thumb is: specific before general, catch-all last. You saw
the consequence here: `*.gz` is a general pattern that also covers `.tar.gz`,
so it has to wait its turn.

The pattern is matched against the whole word, so `*.tar.gz` does not match
`backup.tar.gz.bak`. The `|` inside a pattern list is different from a pipe: it
only separates alternatives and does not run anything.

## Where it shows up

File-type dispatch, option parsing (`-h | --help)`), accepting multiple spellings
(`y | Y | yes)`), choosing a package manager by distro name, and routing log lines
by prefix.

## Going further

`if` and `case` are the tools for big decisions. For tiny ones, Bash offers
a very compact notation, along with a trap that has bitten many experienced
engineers. That is next.
