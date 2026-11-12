# Debrief: sed Line Ranges

Until now you chose lines one at a time: by number with `head` and `tail`, by
content with awk patterns and `sed /x/d`. A range address chooses a whole
*region* of a file, delimited by lines that you recognise by content. The
region opens at the first match of the start pattern, closes at the next match
of the end pattern, and re-arms itself, so every block is selected.

The other half of the idea is the pair `-n` and `p`. By default sed is a
"print everything, with modifications" tool; `-n` turns it into a "print only
what I name" tool. With `/a/,/b/p` it is a block extractor, and with `/a/,/b/d`
the same range removes a block instead. Ranges work with other commands too,
such as `s` for substitutions inside one section of a config file.

A detail to remember: the end pattern is checked starting from the line after
the start line, so a start and end marker on the same line does not close the
range, and a range with no end runs to the end of the file. That is deliberate,
and it explains the unclosed-block test.

Going further: all of these commands print the edited text but leave the file
alone. The next level makes sed change a file in place, safely, with a backup.
