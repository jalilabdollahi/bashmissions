# Debrief: Refuse to Run as Root

Privilege is a loaded tool: the more of it a process holds, the more a single
bug, hostile file name or wrong path can destroy. The security idea is **least
privilege**: run with the smallest power that does the job, and make the script
enforce that instead of hoping people remember. A guard such as "refuse if uid is
0" turns a quiet disaster ("everything is owned by root now") into a loud, early,
one-line error.

`id -u` prints the *effective* user id, the one the kernel uses for permission
checks. Root is always 0. The comparison is numeric on purpose: `(( uid == 0 ))`
cannot be fooled by formatting the way a string comparison can. Order matters
too: check first, then act, so the refusal leaves the system untouched.

In real scripts you will usually write `(( EUID == 0 ))`, because Bash keeps
`EUID` in a variable and no extra process is needed. It is read-only, which is
exactly why the level uses `id -u`: a stub can be controlled by the test, while
the shell's own variable cannot. Both read the same fact.

The reverse guard exists as well: an installer that *needs* root checks
`(( EUID == 0 ))` and says "run this with the proper privileges" instead of
failing halfway on a permission error.

Going further: a script that must run privileged still should not trust its
surroundings. Level 363 locks down `PATH`, so the commands it calls are the
real ones.
