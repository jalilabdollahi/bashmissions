# Common Mistakes

- **Calling `next` in a command substitution.** `r=$(next)` runs in a subshell, so `state` never advances and every draw returns the same number. Make `next` set a global and call it plainly.
- **Using `$RANDOM`.** The sequence for a given seed differs across Bash releases, so "seed 42" does not mean the same thing on the laptop and the server.
- **Skipping a draw for some outcomes.** If `kill` does not draw the parameter, a kill round shifts all later rounds by one. Keep the number of draws per round constant.
- **Using the low bits.** `state % 3` straight from an LCG alternates in patterns; take `state >> 16` first.
- **Forgetting the mask.** Without `& 2147483647` the state keeps growing until the 64-bit multiplication overflows and goes negative, and `%` then gives negative indexes.
- **Breaking protected services.** Filter them out when building the target list, not when picking, otherwise a "protected" pick would silently consume a draw and skip the fault.
