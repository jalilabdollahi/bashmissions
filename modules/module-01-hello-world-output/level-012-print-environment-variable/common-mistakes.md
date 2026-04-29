# Common Mistakes for Print Environment Variable

- Printing the literal text `$HOME` and `$USER`. Single quotes prevent expansion: `echo 'HOME=$HOME'` outputs the dollar signs verbatim. Use double quotes.

- Wrong key order. The expected format is `HOME=... USER=...` — `USER` first will fail the regex.

- Extra spaces or punctuation. The regex is strict: one space between the two `KEY=value` pairs, nothing else.

- Assuming the values are fixed. `$HOME` and `$USER` differ per user; do not hard-code `/root` or your own username.

- Forgetting that `set -u` makes unset variables an error. Both `HOME` and `USER` are normally set, but on a stripped-down environment use `${USER:-unknown}` to provide a fallback.
