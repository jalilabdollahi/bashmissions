# Debrief: Find World-Writable Files

A file that "others" can write is a file anyone with an account on the machine
can change: a PHP upload handler, a cron script, a config file read by a
privileged service. Attackers look for exactly these, because a single writable
script that root later runs is a ladder from a harmless account to full control.
Defenders must be able to find them faster than attackers do.

The good way to ask is with the tool that understands permission bits. `find
-perm -002` reads the mode from the filesystem and applies a bit test:
**-MODE means "all of these bits must be set"**, `/MODE` means "any of them", and
a bare MODE means "exactly this". Mixing them up is the classic audit bug:
`-perm 002` misses nearly every real offender because their modes are 666, 777
or 664.

Parsing `ls -l` is fragile: columns shift, names contain spaces, symbolic
characters like `t`, `s` and `T` in the mode field hide the real bits.

Real audits add more questions: files owned by nobody, set-uid binaries
(`-perm -4000`), and folders that are world-writable without the sticky bit.
Treat a result list as a to-do list for `chmod o-w`, never as an automatic fix.

Going further: level 361 asks the opposite question about the *script itself*:
should it be running with so much power at all?
