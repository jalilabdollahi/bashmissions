# Debrief: PID File Health

A PID file is a claim, and claims decay. The daemon writes its process id when
it starts and (if it exits cleanly) removes the file. A crash, a `kill -9` or a
power cut leaves the file behind, still claiming something that is no longer
true. A script that trusts it will either refuse to start the service ("already
running") or happily send signals to an innocent bystander.

The mental model is **verify, do not trust**: treat any stored state as a hint
and check it against the live system. Here the check has two layers. Existence
(`ps -p`) catches the plain crash. The name comparison catches *PID reuse*: PIDs
are a small recycled pool, and after a reboot yours may belong to something
else entirely. Real init scripts do the same, comparing the executable name or
`/proc/PID/cmdline`.

Technique notes: `$(< file)` reads a file with no extra process, and a regex
check on the content is cheap input validation. `|| true` inside a command
substitution is the standard way to look at a failing command's *output* under
`set -e`. And the three exit codes (0 running, 1 stale, 3 stopped) match
the convention of monitoring plugins, so a scheduler can react differently to
each.

Going further: a PID tells you a process exists. It does not say it is
*working*. The next level watches a heartbeat file's age.
