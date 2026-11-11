# Debrief: Don't Clobber

## What you learned

Redirection with `>` is destructive by default: the file is emptied before
your command even runs. `set -o noclobber` flips the default to "safe", and
`>|` is the explicit "I know what I am doing" version. Making the dangerous
action look different from the safe one is a design pattern you will meet again.

## Under the hood

Normally the shell opens the target with flags "create, truncate". With
noclobber on, it opens regular files with "create, but fail if it exists".
That is one operation inside the kernel, so no other process can sneak in
between a check and the write. `>>` is unaffected, because appending destroys
nothing. Noclobber only guards regular files; redirecting to `/dev/null`
still works.

## In real work

Interactive shells often have noclobber in their startup file after one too
many lost files. In scripts it protects exports, reports and generated
configs, and it is a cheap way to say "first writer wins".

## Going further

Overwriting is one way to lose data; the other is never recording it in the
first place. Next: appending entries to a log, with timestamps.
