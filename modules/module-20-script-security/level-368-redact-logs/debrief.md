# Debrief: Redact Logs

Logs are written for convenience and read by many people: support desks, vendors,
contractors, chat channels. Anything that reaches a log has effectively been
published to all of them, and it stays there for months in backups. The attacker's
mental model: *the strongest lock is useless if the key is printed in the
journal*. So treat logs as an output that needs its own security control.

The best defence is not to log secrets in the first place; scrubbing is the second
line, used at the boundary where a log leaves your control (an export, a bundle,
a ticket attachment). A good scrubber is built from patterns that describe the
**shape** of each secret: `key=value`, an `Authorization` header, a password in a
URL. It keeps the harmless context (the key name, the user) so the log stays
useful for debugging.

Two cautions. Pattern scrubbing only catches what it recognises: a password in a
free-form sentence slips through, so test with real examples and extend the
rules when a new shape appears. And redaction must be applied to *everything*
that leaves, including error output and `set -x` traces.

You met a cousin of this idea in the config module, where printed values were
masked on screen. Here the same defence works on a whole stream, after the fact.

Going further: this module's levels are a checklist you can run against any
script: quote, avoid eval, allow-list, temp files, permissions, privileges, PATH,
globs, links, atomic creation, secret lifetime, scrubbed logs.
