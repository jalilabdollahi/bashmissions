# Default Values

`${var:-default}` is the most-used Bash parameter expansion. It returns `$var` if the variable is set and non-empty, otherwise the literal text `default`. Critically, it **does not assign** anything to `$var`.

```bash
name="${1:-anonymous}"
echo "Hello, $name"
```

Without the colon, the rule changes:

| Form              | Returns default when var is...    |
|-------------------|-----------------------------------|
| `${var-default}`  | unset only                        |
| `${var:-default}` | unset **or** empty string         |

In practice you almost always want the colon form — empty-string and unset usually deserve the same treatment.

The `default` part can itself contain expansions:

```bash
PORT="${PORT:-${DEFAULT_PORT:-8080}}"   # chain of fallbacks
DIR="${DIR:-$(pwd)}"                    # command substitution
```

Pairs with three siblings (covered next):

| Form                | Effect                                                |
|---------------------|-------------------------------------------------------|
| `${var:-default}`   | substitute default; don't assign                      |
| `${var:=default}`   | substitute default and **assign** it to var           |
| `${var:?error}`     | print error to stderr and exit non-zero if unset/empty|
| `${var:+alt}`       | substitute alt only when var **is** set/non-empty     |
