# Debrief: Delete and Squeeze

Cleaning is the unglamorous half of working with data. Exports come with
carriage returns from Windows, extra padding from fixed-width systems, or tabs
from spreadsheets, and every downstream tool treats those as real content. A
carriage return at the end of a line makes `open` and `open\r` two different
words to `sort`, `uniq` and `[[ == ]]`.

`tr -d` and `tr -s` are the sharp end of the same tool you used for mapping.
Deleting removes characters from the stream; squeezing keeps exactly one of any
run, but only for the characters named in the set. This is why squeezing is a
common step before `cut`: with `tr -s ' '` in front, a column separated by
several spaces becomes one a delimiter `cut -d' '` can use.

Notice also the habit this level builds. Instead of one clever command, you
chain two obvious ones. Each is easy to test by itself, and when the output looks
wrong you can run half the pipeline and look.

Going further: sometimes you do not want everything, just a window of the
file. The next level uses `head` and `tail` to cut out a range of lines.
