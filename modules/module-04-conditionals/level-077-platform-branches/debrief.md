# Debrief: Platform Branches

Scripts do not live on one machine. The same file might run on a developer's
Mac, a Debian server and a CI container, and small differences (a flag, a path,
a missing command) break it. Branching on the platform is how one script serves
them all.

## Under the hood

`uname -s` reports the kernel name. The shell can also offer `$OSTYPE`, a built-in
variable with similar information, but its values (`darwin23`, `linux-gnu`) vary
more, so `uname -s` is the more portable habit. Since the output can change
per machine, capture it once and compare against known values; never assume that
"not Linux" means "macOS".

The important design rule is the default branch. A good platform branch lists
the systems it has been tested on and fails loudly on anything else. A script
that silently assumes Linux can do real damage on a system whose `sed` or `date`
behaves differently.

## Where it shows up

Install scripts (`brew` vs `apt-get`), dotfiles, CPU and memory probing, choosing
`open` or `xdg-open`, and the portability layer of any tool used by both
developers and servers.

## Going further

Now you can decide on strings, numbers, files, tools and platforms. The final
level of this module combines them into one realistic gate, with decisions
inside decisions.
