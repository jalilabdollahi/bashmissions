# Debrief: Show Effective Config

The mental model: **configuration needs an explain mode.** When four layers can set
the same value, the question "what is it, and who said so?" has to be answerable by
running a command, not by reading code. Tools that grow up grow this command:
`git config --show-origin`, `docker compose config`, `nginx -T`, `systemctl cat`,
`npm config list`. It is the first thing you run when a customer says "I changed it
and nothing happened".

The implementation idea behind it is provenance: store not only the winning value
but also the layer that produced it, updated at the same moment. Because every layer
writes both tables through the same assignments, the labels can never drift out of
sync with the values.

Technically this level shows what associative arrays do not give you: order. Their
keys come back in an arbitrary sequence, so any output meant for humans or for diffing
must be sorted explicitly, and in a fixed locale (`LC_ALL=C`), or the same input would
print differently on two machines. `compgen -v PREFIX` is the quiet hero: it
discovers variables by name without parsing `env` output, which breaks on values that
contain newlines.

Going further: configuration formats change between releases. The next level migrates
an old-format file into the new one, keeping every setting that still makes sense.
