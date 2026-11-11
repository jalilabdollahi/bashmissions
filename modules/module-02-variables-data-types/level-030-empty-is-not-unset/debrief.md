# Debrief: Empty Is Not Unset

## What you learned
In Bash, "no value" has two meanings: the variable does not exist (unset), or it exists and contains the empty string. The colon in `${var:-x}` says "treat both as missing". Without the colon, only unset counts.

## Under the hood
Every expansion operator in the family comes in two flavours: `-`, `=`, `?` and `+` test "is it unset?", while `:-`, `:=`, `:?` and `:+` test "is it unset or empty?". The shell's variable table can tell the cases apart because an assigned empty string is an entry, and a never-assigned name is not.

This difference matters whenever a caller can say "I really mean nothing". A blank customer note, an empty prefix, a flag that is supposed to turn something off: all are choices that a careless `:-` would overwrite.

## In real work
Pick the colon form by default for settings where empty makes no sense (hosts, paths, ports). Drop the colon for optional text, prefixes, and anything where blank is a legitimate value.

## Going further
Next you will look at how variables travel: which of them a program you start can actually see.
