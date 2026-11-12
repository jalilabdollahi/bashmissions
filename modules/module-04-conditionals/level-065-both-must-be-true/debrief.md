# Debrief: Both Must Be True

`&&` means "and": the whole condition is true only if every part is true. When
you write security or safety rules, "and" is how you stack requirements, and the
`else` branch becomes your safe default.

## Under the hood

Bash evaluates `a && b` from left to right and stops as soon as the answer is
known. If `a` is false, `b` is never run. This short-circuit behaviour matters
when the second test depends on the first, for example "the file exists and it
is readable". It is also the foundation for the shell's one-line idiom
`command1 && command2`, where command2 runs only when command1 succeeded, which
you will use in level 75.

Inside `[[ ]]`, `&&` is part of the test syntax and you may mix it with `||` and
parentheses. In the older `[ ]`, `&&` is not allowed inside the brackets and you
need `-a` or two separate tests.

## Where it shows up

Access policies, deploy gates ("tests passed and a reviewer approved"), safe
cleanup scripts ("it is a directory and it is empty"), and validating input in
ranges.

## Going further

Some rules accept either of two reasons instead. That is the other logical
operator, and it is next.
