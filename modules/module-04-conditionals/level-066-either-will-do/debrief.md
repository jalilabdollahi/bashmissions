# Debrief: Either Will Do

`||` is "or". Where `&&` makes a rule stricter, `||` makes it more forgiving: any
one true part makes the whole condition true. Many real policies are lists of
exceptions, such as weekends, holidays, emergency overrides and test accounts,
and `||` is how you write that list.

## Under the hood

Like `&&`, the operator short-circuits: Bash stops evaluating as soon as one
test is true. The only way for the whole condition to be false is for every
test to be false, which is why the `else` branch of such an `if` means "none of
the reasons applied".

A useful way to think about it is as a truth table. For `a || b`, only the
combination "a false and b false" gives false. In the previous level, `a && b`
was true only for "a true and b true". Mixing both operators is allowed, and
`&&` binds tighter than `||`, but beginners should add parentheses inside `[[ ]]`
to say what they mean.

## Where it shows up

Escalation rules ("priority 1 or VIP customer"), accepting several spellings
("y or yes"), and accepting multiple environment names in one branch.

## Going further

So far we asked questions in the positive. Sometimes the shortest rule is the
opposite: "unless". Negation is next.
