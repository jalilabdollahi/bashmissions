# Common Mistakes for Assign If Unset

- Trying `${1:=foo}` on a positional parameter. Bash rejects it. Always copy to a named variable first.

- Confusing `:=` with `:-`. They look similar; one assigns, one doesn't.
  - `${var:-x}` — temporary substitution; var unchanged.
  - `${var:=x}` — substitution **and** permanent assignment.

- Forgetting the leading `:` in `: "${name:=guest}"`. Without it, the expansion runs as the first word of a command, and Bash tries to execute the resulting string as a command name.

- Using it on a `readonly` variable. The expansion fails because `:=` performs an assignment.

- Assuming `${var:=x}` evaluates `x` lazily. The default expression is evaluated only when needed, but it's still a normal Bash expression — beware of side effects in there.
