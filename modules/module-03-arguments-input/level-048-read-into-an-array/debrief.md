# Debrief: Read into an Array

Level 47 handed fields to a *fixed* set of variables. `read -a` handles the other
case, a list whose length you do not know. Every field becomes an element, and
the array knows its own size, so your script never has to guess.

The `IFS=, read ...` form is worth studying: a variable assignment placed before
a command applies only while that command runs. That is the professional way to
change `IFS` without leaving it changed for the rest of the script, which was the
risk in level 41.

Array access follows a small vocabulary that you will meet again and again:
`${arr[i]}` for one element, `${arr[@]}` for all of them, `${#arr[@]}` for the
count. Indexes start at zero, and negative ones count from the end.

Real uses: parsing CSV-like config values, splitting `PATH`-style lists, reading
a line of hostnames, and turning user input into something you can loop over.

Going further: input is not always harmless. The next level reads something that
must never be shown on screen: a password.
