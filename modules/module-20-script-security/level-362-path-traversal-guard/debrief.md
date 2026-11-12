# Debrief: Path Traversal Guard

Path traversal is what happens when a program builds a path from user text and
the user supplies `..`. The program thinks it is serving files from `public`; the
operating system sees "go up, then into private". Famous breaches (web servers,
archive extractors, upload handlers) have all been this one idea. The attacker's
mental model: *which part of this path do I control, and can I climb?*

A good defence starts by deciding what a legal name looks like, then rejecting
everything else *before* touching the disk. The rule is about **components**: a
slash-separated piece that is exactly `..` climbs, while `summary..final.txt`
does not. Substring bans (`*..*`) are both too strict (they break real files) and,
when written as a replace, too weak: removing `..` from `....//` leaves `../`.
Reject, do not "clean".

Absolute names and the empty string are refused as well; they are the other two
ways to ignore your base folder.

This is a lexical check: it never asks the filesystem. A symlink inside `public`
that points elsewhere passes it, which is why serious services add a resolved
path check or forbid symlinks, as the next levels explore.

Going further: level 365 deals with the symlink side of the problem, and level
364 with listing files without trusting names at all.
