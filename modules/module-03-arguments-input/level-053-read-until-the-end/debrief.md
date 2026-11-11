# Debrief: Read Until the End

Until now each script handled a fixed amount of data. `while read` is the
pattern that handles *a stream of any length*: the loop's condition is the read
itself, so the loop ends exactly when the input does. It is probably the most
common loop in real-world shell scripting, the backbone of log processors, import
tools and "do this for every line" jobs.

Two details make the difference between a toy and a dependable script. First,
initialise your accumulators before the loop, so empty input gives sensible
output instead of blanks. Second, remember that a final line without a newline is
a real line: `|| [[ -n $var ]]` keeps it.

A trap to know about: `cat file | while read ...` runs the loop in a subshell, so
counters you update inside vanish afterwards. Feeding the loop with a redirect
(`done < file`) or letting it read the script's stdin directly, as here, avoids
that.

Going further: the loop you wrote will return in full in module 5. Meanwhile
there is another kind of input to master: options like `--name value` and `-v`.
