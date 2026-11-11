# Debrief: Symlink Checks

A path is not a place; it is a *name that the kernel resolves each time you use
it*. Between "I looked at `notes/halibut.txt`" and "I wrote to it", the name can
be repointed. A symlink makes this sharp: it is a file whose content is another
path, and every ordinary command (`cat`, `>>`, `cp`) follows it silently. If your
script runs with more rights than the user who planted the link, you have just
lent them those rights, the "confused deputy" problem.

`-L` is the question you need, and what makes it different from `-e` and `-f` is
that it examines the link itself. That matters for dangling links, where
`[[ -e ]]` says "nothing is there" right before `>>` creates the target of the
link. Checking the folder matters for the same reason: the link may be an ancestor
rather than the last component.

The check has a limit. Test and use are still two steps, so a very fast attacker
can swap the path in between (the "TOCTOU" race). For ordinary shared-folder
risk it removes the easy attack; for the tight race, the next level shows
atomic creation.

Real tools behave the same way: `tar` and `rsync` have options to refuse or
preserve links (`--no-same-owner`, `--safe-links`), and web servers have
"FollowSymLinks" switches for this very reason.

Going further: level 366 makes "create this file" a single atomic step.
