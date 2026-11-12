# Common Mistakes

- **Capturing the result with `$( )`.** Wrong: `id=$(gen_next invoice)` increments in a subshell, so the next call sees the old counter and numbers repeat. Right: `gen_next invoice; echo "$REPLY"`.
- **Making the counter `local`.** Wrong: `local n` inside the function starts from empty on every call. Right: a global array declared outside, touched only by the generator.
- **One shared counter for all series.** Wrong: a single `count` makes tickets continue from the invoice number. Right: `counters[$kind]`, one entry per kind.
- **Counting from an unset value.** Wrong: skipping the initial `=0`, then `$(( counters[ticket] + 1 ))` under `set -u` errors for a missing key. Right: initialise every series at 0 (and `reset` sets it back to 0).
- **Formatting with `echo`.** `echo "INV-$n"` gives INV-1. Right: `printf 'INV-%04d' "$n"` pads with zeros.
