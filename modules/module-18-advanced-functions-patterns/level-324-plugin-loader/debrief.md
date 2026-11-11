# Debrief: Plugin Loader

`source` is the idea of this level. A normal script runs in a child process
and everything it defines vanishes when it exits. `source` runs the file's
lines in your own shell, so its functions and variables become yours. That is
why a folder of small files can extend a running program.

## Under the hood

The loader depends on a contract: a naming convention (`plugin_NAME`) and a
place to look. Nothing registers anything; the core builds the function name
from the file name and calls it. If the plugin author breaks the contract,
the call fails, which is why bigger systems check first (a later level does).

The glob matters too: the shell expands `*.sh` in sorted order, so plugins
load the same way on every machine. And an unmatched glob is not an error in
Bash: without `nullglob` you get the pattern back as text.

## Security

Sourcing a file means running whatever is in it, with all your permissions.
Only load plugins from folders that only trusted people can write to. Priya will
ask about that.

## In real work

`/etc/profile.d/*.sh`, `/etc/bash_completion.d`, and every dotfile
framework use exactly this loop.

## Going further

Plugins often want to run code at fixed moments (before and after a deploy).
The next level collects such callbacks in arrays, called hooks.
