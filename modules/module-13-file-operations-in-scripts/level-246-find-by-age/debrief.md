# Debrief: Find by Age

## What you learned

Every file carries a modification time (mtime), and `find` can filter by it
in two styles: **absolute** (`-mtime +N`, "older than N days") and
**relative** (`-newer FILE`, "changed after this other file"). The
relative style is how incremental backups, build systems and sync tools
decide what to do.

## Under the hood

`-mtime +N` takes the difference between now and the file's mtime, divides by
24 hours and *discards the fraction*. A file 30.9 days old has a count of 30,
so `+30` does not match it yet. People are regularly caught by this
rounding. `-newer` compares two mtimes directly, with no arithmetic.

The mtime changes when the file's content is written, not when it is read
and not when it is renamed. Copying a file gives the copy a new mtime unless
you preserve it (`cp -p`).

The tests in this level's data use `touch`-style fixed dates so the output
does not depend on today's date; in your own tests, `touch -t
YYYYMMDDhhmm file` makes files "old" on demand.

## In real work

Log rotation, cache cleaning, "files changed since last deploy", incremental
backups: all are age queries. A marker file left by the previous job, as
here, is more reliable than remembering a date.

## Going further

You can now find things and measure them. Next, a different kind of
safety: making sure two copies of a script never run at the same time.
