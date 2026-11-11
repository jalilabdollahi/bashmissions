# Debrief: Validate an IPv4 Address

Regexes understand *text*, not *numbers*. They can say "one to three digits" but
"at most 255" is a statement about value, and values belong to arithmetic. The
mature pattern is to **let the regex verify the shape and extract the pieces,
then let normal code judge their meaning**. You will use this split constantly:
timestamps, versions, ports (1 to 65535), percentages (0 to 100).

The detour through `10#` is a famous Bash trap. Numbers that start with `0` are
read as octal inside `(( ))` and `$(( ))`, so `08` and `09` are errors and `010`
is 8. Data from the outside world, such as zero-padded octets, dates and
hours, is full of leading zeros. Whenever you capture digits from text and do
arithmetic on them, prefix `10#`.

Notice, too, how the near-misses shaped the regex. `1234.1.1.1` would be shorter
than a naive "digits dot digits..." pattern allows, which is why `{1,3}` and the
anchors are in place. A validator is a list of ways the input can be wrong, and
each rule you add closes one of them.

You can still write the range inside the regex using alternation. For an octet:
`(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])`. Try to read it once, then
appreciate why the two-step version above is easier to maintain.

Going further: dates need the same combination, with a twist: the allowed day
depends on the month and on leap years.
