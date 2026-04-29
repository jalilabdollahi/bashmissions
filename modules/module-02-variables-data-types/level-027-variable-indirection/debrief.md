# Variable Indirection

`${!name}` performs **indirect expansion**: it treats the value of `name` as the name of *another* variable, and expands to that variable's value.

```bash
COLOR_RED="red"
COLOR_BLUE="blue"
key="COLOR_RED"
echo "${!key}"   # red
```

Step by step:

1. `${!key}` — Bash sees the `!` prefix.
2. Reads `$key` first → `COLOR_RED`.
3. Looks up `$COLOR_RED` → `red`.
4. Substitutes `red`.

Real-world uses:

- Dispatch by name, e.g. logging: pick a level-specific prefix.
  ```bash
  PREFIX_INFO="[INFO]"
  PREFIX_WARN="[WARN]"
  level="INFO"
  echo "${!}: hello"   # almost — see below
  ```
- Reading config values where the key is computed at runtime.
- Building a poor-man's associative array in shells without `declare -A` (Bash 4+ has real associative arrays — prefer those).

Limitations and gotchas:

- `${!name}` doesn't accept array subscripts in the inner reference.
- Modern code prefers **name references** (`declare -n alias=target`) for clearer intent. They're a Bash 4.3+ feature.
- The `!` prefix is overloaded: `${!prefix*}` and `${!prefix@}` enumerate variables starting with a prefix; `${!arr[@]}` lists array indices. Same character, different operation depending on context.
