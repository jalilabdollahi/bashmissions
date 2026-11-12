# Debrief: Join with a Separator

Joining is the mirror image of splitting. Splitting turns one string into a list
at the delimiter; joining turns a list into one string with a delimiter. The
usual mistake is to write the separator after every item and end up with a dangling
one. The `${joined:+$sep}` idiom avoids special cases in the loop, because the
decision "is this the first item?" is answered by "is there anything yet?".

Notice `"${hosts[@]}"`. The quotes matter: they keep each element as one word
even if it contains spaces (`gull anchor` stayed whole in the tests). Without
quotes, the element would be split again. The `@` form gives a separate word per
element; its sibling `"${hosts[*]}"` glues all elements into one word using the
first character of `IFS`. That is the quick route for one-character separators,
and a trap for longer ones, which is why the loop is the general method.

You will use joined lists all the time: `--allowed-hosts a,b,c`, SQL `IN (...)`
lists, `PATH`-style variables, log prefixes, command lines assembled from options.

Going further: next come the checks that decide *which* items go into such a list,
starting with "does this string begin or end with something?".
