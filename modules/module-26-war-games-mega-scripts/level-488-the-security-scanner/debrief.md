# Debrief: The Security Scanner

Most break-ins are not clever. They are a readable key, a writable file in a web root, a forgotten setuid helper. A scanner that checks the boring things every night finds more real problems than most advanced tooling, and it is almost entirely built from `find`.

The two details to remember are both about meaning. First, `find -perm` has three modes (exact, "all bits", "any bit") and the portable spelling of "any bit" is a list of "all bits" tests. Second, config files have *semantics*: sshd takes the first value and ignores case. To judge a setting, read the file with the program's own rules, not with a `grep` for the word "yes".

You also built a small severity model, which appears in every audit tool: rank at the moment of recording, sort at the end, and let the exit status be a policy (`--fail-on`) instead of a constant. The same script can warn in development and block a release in production.

Finally, the scanner reports where secrets are, never what they are. Tools that process secrets should assume their output ends up in a ticket.

Going further: when the scanner finds something, the next question is what to keep before touching it. The forensics collector, next, preserves evidence with hashes so nothing changes after you looked.
