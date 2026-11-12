# Debrief: INI Sections

The mental model: **structure is state.** The moment a file format has headers,
indentation or nesting, you can no longer judge a line by itself; you must remember
where you are. A parser for such a format is a loop plus a few variables that
record the context (here: "inside the wanted section or not"). The same pattern
parses YAML-ish files, Markdown front matter, `/etc/hosts`-style blocks, systemd
units and `git config`.

Good state machines make transitions explicit. Here every header unconditionally
sets `inside` to 1 or 0, so there is no way to leave a stale value behind, and a
file that mentions the same section twice simply works. Choosing the right default
for "before any header" (outside) makes the global-settings edge case disappear
without a special rule.

Parsing details also decide whether the tool is predictable. Splitting at the first
`=` keeps URLs with query strings intact. Declaring "no inline comments" is a
legitimate choice; the dangerous thing is guessing, because a `#` inside a URL
fragment would be silently cut off. Real INI dialects differ here, which is why
you document the rules you chose, as the objective did.

Going further: the program that reads the config usually runs for a long time, and
administrators change the file while it runs. The next level reloads the
configuration when the process receives a signal.
