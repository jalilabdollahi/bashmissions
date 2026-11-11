# Debrief: Trace with set -x

Most of debugging is replacing "I think the script does X" with "I watched the
script do X". `set -x` (xtrace) is the quickest way to watch.

With the option on, Bash prints every simple command to stderr right before it
executes it, and it prints the command *after* expansion. That is the whole
trick: your source says `mkdir -p "$dest"`, the trace says
`mkdir -p backups/harbour`. A variable that is empty, a glob that matched
nothing, a name that split into two words: all of it is visible in the trace
because you see what the command really received. Quoting is shown too, with
single quotes around any word that contains spaces or special characters.

The `+ ` at the start of each line is the value of the variable `PS4`, the
"trace prompt". Because the trace goes to stderr, redirecting stdout does not
swallow it, and `2>trace.txt` captures it without touching the real output.

In real work this is the first thing to try on a script that "works on my
machine": `bash -x script.sh args 2>&1 | less`. Cron jobs, deploy scripts and
CI steps all become readable.

Going further: tracing everything is noisy. The next level shows how to trace
only the few lines you actually suspect.
