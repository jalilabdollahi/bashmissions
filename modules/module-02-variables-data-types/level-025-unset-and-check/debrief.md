# Debrief: Unset and Check

## What you learned
A variable can be in one of three states: it has a value, it is set but empty, or it does not exist. `unset` moves it to the third state, and `${var+word}` is the way to tell the first two apart from the third.

## Under the hood
Bash keeps variables in a table. `unset` removes the entry; assigning an empty string keeps the entry with an empty value. The expansion `${var+word}` looks at the table, not at the value: if the entry is there it gives `word`, otherwise nothing. That is why this is the right tool for "was this setting provided at all?".

Without the colon the test is about existence. With a colon (`${var:+word}`) an empty value counts as missing as well. You will see the colon forms again in the fallback levels.

## In real work
Secrets such as tokens and passwords should not live longer than needed. Removing them with `unset` limits what a later bug, or a child process, can reach. Existence checks are also how scripts distinguish "the caller passed an empty value on purpose" from "the caller forgot".

## Going further
So far all values were text. Next, a variable that does arithmetic.
