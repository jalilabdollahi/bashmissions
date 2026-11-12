# Debrief: Dependency Check

A script that discovers a missing tool in the middle of its work is the worst kind
of failing script: it has already changed things, and now it stops. The professional
habit is the pre-flight check: at the top of the script, before any change, verify
that everything the run needs is present, and refuse to start otherwise.

Two decisions make that check pleasant. First, `command -v` is the standard test: it
answers "would the shell find this?" for programs, builtins and functions alike,
and it works the same on macOS, Debian and BusyBox. Second, collect instead of
stopping. A missing-tools message that lists all of them lets the person fix their
machine in one go.

The pattern generalises beyond tools. Required environment variables, config
files, writable folders and enough disk space can all go into the same checklist.
It pairs naturally with the validate-before-acting level: *look at everything
first*, then act.

A subtle point worth remembering: `command -v` proves the tool exists, not that it
is the right version or that it works. When versions matter, run `tool --version`
and compare it too.

Going further: telling the user what is missing is half of a good error. The last
levels of the module are about the other half: how to word an error so that the
person reading it knows what to do.
