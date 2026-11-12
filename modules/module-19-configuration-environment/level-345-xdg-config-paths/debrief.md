# Debrief: XDG Config Paths

The mental model: **a program should not decide where the user's files go; it
should ask.** The XDG Base Directory specification gives every user a small set of
environment variables (`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`) and
agreed defaults for when they are not set (`~/.config`, `~/.local/share`,
`~/.cache`). Respecting it keeps home directories tidy and lets people move all
configuration, for backups or for a test sandbox, by changing one variable.

The details are where scripts go wrong. "Not set" and "set to an empty string" are
different states to the shell but the same to the standard, so use `:-`. A relative
path in the variable must be ignored. And the base is chosen once: you do not fall
back from the XDG folder to `~/.config`, because the user who set the variable
meant it.

Supporting a legacy location after the new one is how well-behaved tools migrate
their users without breaking anyone: look in the new place, then the old.

Under the hood, `[[ $x != /* ]]` is a glob comparison; `[[ -f ]]` calls `stat`
and asks "regular file?", which is stricter than `-e`.

Going further: config does not only live in the home folder. Projects carry their
own, and a tool run from a deep subfolder has to climb up to find it. That is the
next level.
