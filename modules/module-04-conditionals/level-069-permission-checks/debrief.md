# Debrief: Permission Checks

`-r`, `-w` and `-x` answer "can I?" rather than "what does the mode say?". The
difference matters: a file readable only by its group is unreadable to you if
you are not in the group, and the tests take that into account because the
system itself answers them for the user running the script.

## Under the hood

Bash asks the operating system to check access for the current user and
groups. For a directory, `-x` means "may enter it" and `-w` means "may add or
remove entries". Root is the exception: it can read and write nearly everything,
so `-r` and `-w` are almost always true for root. That is one reason scripts that
check their rights should be tested as a normal user.

Notice the pattern that the solution uses: set a default, then override it
inside an `if`. Three tiny independent `if` blocks (no `else`, no `elif`)
are right whenever the answers do not exclude one another.

## Where it shows up

Pre-flight checks before a deploy, making sure a private key is not world
readable, checking that a log directory is writable before starting a service,
and giving a clear error instead of a cryptic "Permission denied" from deep inside
another tool.

## Going further

A file can exist and be perfectly readable and still have nothing in it. That
is a different question, and the next level answers it.
