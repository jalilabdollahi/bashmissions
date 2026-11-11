# Debrief: Alternation

`|` is the regex "or". Where quantifiers say *how many*, alternation says *which
one of these*. Its mental model is a fork in the pattern: at that point the
engine tries the first branch, and if the rest of the pattern cannot be satisfied
it tries the next.

The part people get wrong is the *reach* of the fork. `|` splits the whole
expression around it, as far as the nearest enclosing parentheses or the edges of
the pattern. So `^yes|no$` means "starts with yes, or ends with no". What you
usually want is `^(yes|no)$`. Whenever you use `|`, wrap it in a group.

The second lesson is *boundaries*. A regex finds the first place it fits, and
`DROP` fits inside `DROPPED`. Whenever the thing you accept is a whole word,
say what may come after it (a space, the end, a quote) just as you would say what
may come before it. The same group trick, `( |$)`, handles "space or end".

In real work alternation is how you build a filter for several severities
(`ERROR|FATAL|PANIC`), several file extensions, or several status words, with one
test instead of a pile of `||`.

Going further: until now you only asked yes or no. Next you will make the regex
hand back the piece it matched.
