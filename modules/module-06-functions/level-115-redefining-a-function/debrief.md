# Debrief: Redefining a Function

Function definitions are not declarations that must be unique. They are
assignments to a table of names. Defining `notify` a second time simply stores a
new body under the same name; the old one is gone (you can look at what is
currently defined with `declare -f notify`).

Because calls are resolved by name at run time, code that was written earlier
automatically uses the newer definition. `report` was written before your
`notify` existed, yet it calls yours. This makes a simple customisation system
possible: a library supplies defaults, and each site or environment overrides
just the few functions it cares about. Many real projects work this way:
a default `log` function replaced by one that writes to a file; a `deploy_hook`
that does nothing unless you define it; test scripts that replace `curl` or `date`
with fakes (this very game does something similar with stub commands).

The risk is accidental redefinition: two libraries both defining `die` or
`log`, with the later `source` silently winning. Prefixing library function names
(`storage_kb_to_mb`) avoids it. And a function takes priority over an external
program of the same name; `command ls` bypasses functions when you need the
original.

Going further: one of the most reusable helpers is the one that stops a script
with an error message. That is the next level.
