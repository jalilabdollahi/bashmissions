# Debrief: Strip the Longest Prefix

`#` and `##` differ only in how greedy the pattern is, and the difference
matters whenever the pattern can match in more than one way. Think of the `*` as a
rubber band: `#` pulls it in until the first fit, `##` stretches it until the
last possible fit.

`${path##*/}` is such a common idiom that you will meet it in start-up scripts all
over Linux: it is the built-in equivalent of `basename`. Notice what it does with
awkward input. No slash: the value is returned as is. Trailing slash: you get an
empty string, because after the last slash there is nothing. A good script decides
what should happen in that case; here the specification said "print an empty name".

Under the hood, Bash tries the pattern against successively longer or shorter
prefixes of the value. No processes, no pipes, no temporary files.

Where it shows up: pulling a file name from a path, a version from a tag
(`${tag##*-}`), a username from `domain\user`, the last label of a dotted name.

Going further: the mirror images, `%` and `%%`, trim from the right. Together the
four operators let you take any path apart.
