# Error If Unset

`${var:?message}` is the **fail-fast** parameter expansion. If `$var` is unset or empty, Bash prints `var: message` to stderr and exits the script (or returns from the function) with a non-zero status.

```bash
name="${1:?missing argument}"
echo "Hello, $name"
```

Run with no argument:

```
$ ./solution.sh
./solution.sh: line 4: 1: missing argument
$ echo $?
1
```

This is the canonical way to assert that a positional parameter was provided, in one line and without an `if`. It pairs naturally with `set -euo pipefail` at the top of a script.

| Form               | When var is unset/empty...                            |
|--------------------|-------------------------------------------------------|
| `${var:?message}`  | print `var: message` to stderr, exit 1                |
| `${var?message}`   | same, but only fires on **unset** (empty passes)      |

Common patterns:

```bash
: "${API_KEY:?set API_KEY in your environment}"
: "${1:?usage: $0 <input-file>}"
```

The leading `:` is the no-op command — used when you only care about the side-effect (the assertion) and not the value.
