# Debrief: Middleware Chain

A middleware chain is function composition: `f3(f2(f1(x)))`, where the list
of functions is data. Because each step has the same interface (text in, text
out), steps do not know about each other and can be combined freely, reordered,
or reused. It is the same idea as a shell pipe, except the stages are
functions that run in your own process and are picked at run time.

## Order is semantics

`trim clip` and `clip trim` give different answers: clip first and you may cut
into the padding, then trim; trim first and you keep twelve useful
characters. The chain is a program, and its order is the logic. Web servers,
log processors and request pipelines all rely on this: authentication before
logging, decompression before parsing.

## Under the hood

`value=$("mw_$step" "$value")` is the engine. Command substitution captures
what the step prints and the assignment carries it forward. Each step runs in a
subshell, which is fine because the steps are pure: they use only their
argument and keep no state. (A step that needed to remember something would
have to use a variable instead, as in the generator levels.) Printing with
`printf '%s'` matters: `echo` could swallow a text like `-n` and would append a
newline; and `IFS= read -r` is what makes padded input arrive intact.

Validating the chain up front means the program either runs completely or not
at all.

## In real work

Text normalisation before comparison, request handlers, build pipelines with
configurable passes. It is the same pattern wherever "a list of small
transformations" appears.

## Going further

Some wrappers do not change the data; they change *how* a command is run.
Next, a retry wrapper that works around any command.
