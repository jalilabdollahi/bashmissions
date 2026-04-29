# Common Mistakes for Uppercase Variable

- Trying `${var^^}` on Bash 3.x (older macOS): `bad substitution` error. Use `tr '[:lower:]' '[:upper:]'` for portability or `#!/usr/bin/env bash` to ensure a modern Bash if installed.

- Confusing single-caret `^` (first char only) with double-caret `^^` (all chars). Same with `,` vs `,,`.

- Quoting issues: `echo $var^^` — the caret is a literal character there. The expansion form is `${var^^}` *inside* `${ }`.

- Trying to chain expansions: `${${var^^}//x/y}` — Bash doesn't support nested expansions. Use a temporary variable.

- Expecting non-ASCII letters to convert. Behaviour depends on the shell's locale (`LC_CTYPE`). With `C` locale, only ASCII A–Z / a–z are recognised.
