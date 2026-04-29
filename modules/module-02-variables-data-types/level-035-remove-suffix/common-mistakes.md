# Common Mistakes for Remove Suffix

- Mixing up `%` (suffix) and `#` (prefix). Mnemonic: `#` is at the start of `#!/bin/bash`, `%` looks like the end of a sentence (sort of — it's a stretch; just memorise it).

- Confusing single `%` (shortest) with double `%%` (longest). For `archive.tar.gz`:
  - `${file%.*}` → `archive.tar` (drop only `.gz`)
  - `${file%%.*}` → `archive` (drop everything from the first dot)

- Treating the pattern as regex. `${var%.tar.gz}` matches the **literal** suffix `.tar.gz`, not "tar followed by gz".

- Using `${var%/*}` and being surprised when it doesn't strip *everything* after the last slash on a string with no slash. The pattern doesn't match, so the value is unchanged — that's the documented behaviour.

- Forgetting these patterns are **anchored**: there's no implicit `*` at the start or end. `${var%.bak}` matches only when the value literally ends with `.bak`.
