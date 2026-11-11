# Debrief: Allow-List Input

Validation comes in two shapes. A **block-list** says "reject these bad values"
and an **allow-list** says "accept only these good values". Attackers are
creative, so the block-list is a race you lose slowly; the allow-list is a
fence with a gate you control. Whenever the set of legal inputs is small or can
be described exactly (service names, region codes, digits only), use the
allow-list.

How you compare matters as much as what you compare. `grep` by default reads
its pattern as a regex and matches anywhere in a line, so `grep -q "$name"
list.txt` accepts `.*`, `we` and even an empty string. `-F` removes the regex,
`-x` removes the "anywhere", and `--` removes the possibility that the value is
a flag. Inside Bash, `[[ $x == $y ]]` has a similar trap: an unquoted right-hand
side is a glob pattern.

You will meet allow-lists as the list of valid environments in a deploy tool, the
sudoers command list, firewall rules ("deny all, allow these"), and upload
filters that accept `.png` and `.jpg` instead of banning `.php`.

An allow-list also gives you a clean place to log refusals: the denied message
tells Priya exactly which value tried to get in.

Going further: allow-listing works on *values*. Level 362 applies the same
thinking to file *paths*, where the attacker's trick is `..`.
