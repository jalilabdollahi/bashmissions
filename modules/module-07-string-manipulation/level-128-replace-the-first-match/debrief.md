# Debrief: Replace the First Match

`${var/pattern/replacement}` is Bash's find-and-replace. One slash means "once":
it finds the leftmost match, replaces it, and stops. Everything else in the
string, including later copies of the same text, stays exactly as it was.

The thing most people miss is that the middle part is a **glob pattern**, as in
the previous four levels. That is convenient when you want it (`${path/*.}`
style tricks) and dangerous when you do not, for instance when the text comes
from a user or a config file. Putting the variable in double quotes inside the
expansion switches the pattern machinery off, so the text is matched literally.
Whenever data, not code, supplies the search term, quote it.

The replacement text is plain: no pattern rules apply to it. There is no error for
"no match": the result is the original value, which makes the operation safe to
apply unconditionally.

This is how config files, hostnames and templates get patched in scripts:
`"${url/http:/https:}"`, `"${cmd/--debug/--quiet}"`.

Going further: when you want *every* occurrence replaced, one more slash does it.
The next level uses that to clean up file names.
