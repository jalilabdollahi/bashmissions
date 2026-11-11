# Debrief: Strip a Suffix

`%` is the right-hand twin of `#`. It trims from the **end** of the value, and a
single `%` takes the shortest suffix that matches the pattern. Together with the
two prefix operators you now have a small, complete toolkit for taking apart
anything that has a recognisable beginning or end.

The classic uses are renaming files and building output names. Converting
`photo.jpeg` to `photo.png` is `"${f%.jpeg}.png"`. Making a backup name is
`"${f%.*}.bak"`. Unpacking a tarball into a folder named after it is
`mkdir "${f%.tar.gz}"`.

Remember that a pattern is anchored to the end: `${f%.gz}` removes `.gz` only if
the name really ends with it. If it does not, you get the original value back,
which is why this expansion is safe on mixed input.

One behaviour to watch: a name that *starts* with a dot, such as `.bashrc`, has
nothing before that dot. `${f%.*}` of `.bashrc` is an empty string. Real tools
special-case hidden files, and now you know why.

Going further: if you want to remove ALL the extensions, or everything from the
first dot of a hostname onward, you need the greedy `%%`. That is next.
