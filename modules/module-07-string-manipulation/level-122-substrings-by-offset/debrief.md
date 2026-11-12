# Debrief: Substrings by Offset

`${name:offset:length}` treats the value as a row of numbered boxes, starting at
box 0, and hands you a run of them. Leave out the length and you get everything
from the offset to the end: `${stamp:9}` is `093015`.

Fixed-width data is more common than you might think: timestamps from backup
tools, old mainframe exports, license plates, product codes like `LF-2024-0042`,
and the first characters of a hash. Whenever the *position* tells you what a
character means, an offset slice is the shortest tool.

Two things to keep in mind. First, the results are strings, so `09` stays `09`.
If you wanted arithmetic, `$(( 09 + 1 ))` would trip over the leading zero (it
reads it as octal), a trap for a later module. Second, if the offset is past the
end, you get an empty string rather than an error, so garbage input produces
blank fields quietly. Validate the length first (previous level) when the input
is not trusted.

Going further: counting from the front breaks when the length varies. The next
level counts from the end, which suits things like file extensions and card
numbers.
