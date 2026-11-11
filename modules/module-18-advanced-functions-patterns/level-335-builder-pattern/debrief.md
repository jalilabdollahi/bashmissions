# Debrief: Builder Pattern

A builder splits "describing" from "making". You assemble a description
through small steps, each of which can refuse a bad piece, and one final
step turns the finished description into the result. The payoff is
readability at the call site (`cpus=4 ram_gb=16` says what it means),
defaults that live in one place, and errors that point at the right field.

## Under the hood

Bash has no objects, so the "object" is an associative array and the "methods"
are functions that agree to touch it. That is the whole pattern. Two details
are worth copying:

- **Validate at the edge, relate at the end.** A setter can only know about its
  own value; rules that involve two fields (RAM against CPUs) belong to
  `build`, after all options have arrived, so the order of the options does
  not matter.
- **Produce output last.** Because nothing is printed before `build`
  succeeds, a failed run leaves stdout empty. A caller can treat
  "empty stdout, exit 2" as "nothing was created". Half an answer is often worse
  than none.

Using `|| exit 2` after each setter is how an error inside a function becomes
the script's own exit status without `set -e` guessing for you.

## In real work

Command builders (assembling `rsync` or `curl` flags from options), config
generators, and request payloads all benefit. When you catch yourself passing
a fourth positional argument, consider a builder.

## Going further

A builder fixes *what* is made. Next, how to swap the *algorithm* used for a
step without touching the code around it: the strategy pattern.
