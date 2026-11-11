# Debrief: Structured Logs

Free-form log sentences are written for people and are painful for programs:
every message has its own shape, so every search needs its own regex. A
structured line trades a little prose for a lot of power. The same sentence
becomes `msg="disk is filling" host=eel pct=91`, and now
`grep 'host=eel'` or an `awk` that splits on spaces can pull out exactly the
field you care about.

The format you built is called *logfmt*. Its rules are few, and each rule
exists for a parser's benefit: the key never contains spaces; a value is either
a bare word or double-quoted; a quote inside a quoted value is escaped. Skip the
escape and one odd message corrupts the line. Notice that the quoting decision
lives in one place, in the builder. If every caller formatted its own fields,
you would eventually get an unquoted space in production.

Under the hood this is plain string surgery: `${x%%=*}` removes the longest
suffix beginning with `=`, `${x#*=}` removes the shortest prefix ending with
`=`, and `${x//a/b}` replaces every match.

Where it shows up: Go and Kubernetes services, Heroku-style platforms,
journald fields, and any log pipeline that feeds a dashboard.

Going further: a line like this is easy to parse, so soon you will parse
system tools' output (`df`, `uptime`) and turn it into alerts.
