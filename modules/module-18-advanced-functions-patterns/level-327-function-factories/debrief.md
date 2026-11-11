# Debrief: Function Factories

A function definition is just text that Bash reads. `eval` lets you build that
text with variables and run it, so a loop can mint functions that differ in
a detail. The generated `log_warn` has "WARN" baked into its body: it
remembers the value from the moment it was made, a poor man's closure.

## Why eval needs a leash

`eval` parses its argument as shell code. If the level were `x; touch pwned`,
the string would contain a second command, and the factory would run it with
your permissions. Safe use has three rules, all in this level:

1. **Validate against a whitelist pattern before building the text.**
   Letters only, no spaces, no quotes, no `$`.
2. **Only splice trusted, checked values into the string**; everything
   that must stay data (the message) is passed later as arguments to the
   generated function, never pasted into the text.
3. **Escape what must expand later** (`\$*`), and when in doubt print the
   string with `echo` first.

## Under the hood

The definition lives in the shell's function table. The body does not
change when `level` changes afterwards, because the value was substituted
into the text.

## In real work

Test frameworks generate `assert_*` helpers, and config tools generate
getters and setters for each setting. Prefer a plain function with an
argument when you can; reach for a factory when the call sites need distinct
names.

## Going further

A function that already exists can also be wrapped, adding behaviour without
editing it: decorators come next.
