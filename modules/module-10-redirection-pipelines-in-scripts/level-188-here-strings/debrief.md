# Debrief: Here-Strings

## What you learned

`<<<` is the small sibling of the here-document: it feeds one string (after
expansion) into a command's standard input. It replaces the `echo "$x" | cmd`
habit.

## Under the hood

`echo "$x" | cmd` creates a pipeline: a new process for echo, a pipe, and (in a
loop) a subshell around the receiving side. `cmd <<< "$x"` just gives the
command a temporary file or pipe holding the string, so everything runs in
your current shell. The string always gets a newline appended; that is why
`wc -c <<< "abc"` says 4.

Word splitting and globbing do not apply to the single word after `<<<`
(it is expanded like an assignment), but quoting still keeps your spaces
intact in the rest of the line, so quote the variable.

## In real work

`read a b c <<< "$line"` to split a string into fields, `grep -q pattern <<<
"$var"` to test a variable, `while read ... done <<< "$list"`. The last one
keeps variables alive after the loop, which a pipe would not.

## Going further

You have now met every way to feed input. Time to chain commands: the next
level is the classic multi-stage pipeline.
