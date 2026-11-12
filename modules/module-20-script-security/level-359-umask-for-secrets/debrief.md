# Debrief: umask for Secrets

Security fixes that run *after* the dangerous moment are weak fixes. A file that
is created world-readable and tightened a millisecond later has still been
readable, and a process that opened it in that millisecond keeps access. The
attacker's mental model: "watch the directory, open anything that appears".

`umask` moves the decision to the right place. It is a mask of permission bits
inherited by every process you start, subtracted from what the creating program
asks for. `077` means "group and others get nothing", so new files are 600 and new
folders 700, with no gap at all. That is why ssh keys, `.env` files with
credentials and database dumps are all created under a restrictive umask.

Because the mask is inherited, keep its scope as small as the secret itself. A
subshell `( umask 077; ... )` is perfect: the setting disappears when the
parentheses close, so unrelated files do not turn private by accident (or fail
to be shared when they should be).

Remember that umask only *removes* bits. It cannot make a file more open, and it
does not repair existing files. For those you still need `chmod`, which is the
tool for audits, not for creation.

Going further: level 360 flips to the auditor's side and hunts for the files that
were *not* created carefully, with `find -perm`.
