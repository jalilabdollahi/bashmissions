# Debrief: How Long Is It?

A shell variable is just a string, and the shell can answer questions about it
directly. `${#name}` is one of a family of *parameter expansions*: a `$` followed
by braces with an operator inside. The `#` at the front means "length of". Every
other lesson in this module is a variation on the same shape: `${name<operator>...}`.

Under the hood nothing is spawned. The shell already knows how long the value is,
so the expansion costs almost nothing. That matters inside loops that run
thousands of times, where `$(echo ... | wc -c)` would start two processes per turn.

Two details worth remembering. Spaces count as characters, so a username made of
spaces still has a length. And the length of an unset or empty variable is `0`,
which makes the empty case easy to test without any special code.

You will see this in real scripts for validating input (port numbers, passwords,
hostnames, which have a 63-character label limit) and for formatting output.

Going further: knowing the length is half of cutting a string. The next level
uses offsets to pull a piece out of the middle.
