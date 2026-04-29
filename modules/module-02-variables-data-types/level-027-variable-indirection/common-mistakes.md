# Common Mistakes for Variable Indirection

- Confusing `${!name}` with `$!`. `$!` is the PID of the most recent background process — completely unrelated.

- Putting the `!` outside: `!${name}` is parsed as history expansion in interactive shells and a syntax error in scripts. The `!` must be **inside** the braces.

- Trying to use it on the left side of an assignment: `${!name}=value` doesn't work. Use `declare -n alias=target; alias=value` instead.

- Believing `${!name}` walks the chain forever. It performs **one** dereference: name of variable → value (which is taken as another name) → final value. It doesn't recurse further.

- Quoting confusion: `echo "${!key}"` is fine. `echo '${!key}'` (single quotes) prints the literal `${!key}`.
