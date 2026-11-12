# Debrief: Mask Secrets

The mental model: **secrets leak through output, not only through files.** Logs,
`--debug` dumps, error messages, CI transcripts and support tickets are copied
around, indexed and kept for years. A script that handles credentials needs a
single place where values are prepared for display, and everything printed goes
through it. "Mask by default, reveal on purpose" is the safe direction.

Masking policy is a trade-off. Showing nothing makes two keys indistinguishable
("which token is this, the old one or the new?"). Showing the last four
characters answers that question while leaking very little, but only if the
secret is long enough: revealing four characters of a six-character password is a
disaster, which is why the threshold exists. Decide it once, write it down, test
the boundary (11 versus 12 characters here).

Two details matter in the implementation. Match secrets by name pattern, so new
settings that follow the convention are protected without anyone editing the
script, and look inside values too, since connection strings carry passwords
under innocent names such as `DATABASE_URL`. And mind the glob: `*_KEY` catches
`SIGNING_KEY` but, thanks to the underscore, not `MONKEY`.

Going further: the strongest way to keep a secret out of output is to never put it
in the config at all. The next level reads secrets from files named by a
`*_FILE` variable, the convention Docker and Kubernetes use.
