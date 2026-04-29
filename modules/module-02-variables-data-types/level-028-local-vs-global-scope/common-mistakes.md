# Common Mistakes for Local vs Global Scope

- Forgetting `local`. An assignment inside a function silently mutates (or creates) a global variable — a bug that surfaces only when two functions both happen to use the same name.

- Using `local` at the top level. It's only valid inside a function definition.

- Believing dynamic scope works like lexical scope. Inside a function called by another function, you can see the caller's locals (unless the caller used `local`). This is rarely useful; treat it as a hazard.

- Combining `local` with positional parameters: `local 1="$1"` is invalid (you can't make `$1` itself local). Instead: `local name="$1"`.

- Forgetting that `local` requires the variable name as its argument: `local name=value` is correct; `local "$name=value"` does word splitting and breaks.
