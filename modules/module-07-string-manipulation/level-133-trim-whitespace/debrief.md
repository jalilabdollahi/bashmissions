# Debrief: Trim Whitespace

Bash has no `trim` function, but you now have the parts to build one: the
greedy prefix and suffix removers plus a pattern for "a run of blanks". That
pattern needs `extglob`, an option that unlocks the extended operators
`+( )`, `*( )`, `?( )`, `@( )` and `!( )`. It is off by default because it
changes how some characters are parsed, so a script that uses it turns it on
explicitly, near the top, where the next reader can see it.

The character class `[[:space:]]` is worth learning in full. It means space, tab,
newline and a few rarer characters, whereas a literal space in the pattern would
miss tabs. Classes such as `[:digit:]`, `[:alpha:]` and `[:upper:]` work the same
way and you will meet them again with regular expressions.

Where does this matter? Whenever text comes from the outside: CSV exports, user
input, command output and config files with indentation. A stray blank is invisible
on screen but makes `[[ $name == "Tidewater Books" ]]` false, which is a miserable
bug to find. The brackets we printed here are a debugging habit: wrap values in
visible markers when you suspect whitespace.

Going further: the next level shapes values for output by fixing their width,
which is the opposite job: adding blanks on purpose.
