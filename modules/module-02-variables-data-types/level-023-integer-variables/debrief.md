# Integer Variables

Bash variables are *untyped strings* by default. The shell evaluates them as numbers only inside arithmetic contexts: `$(( ))`, `(( ))`, `[[ ]]` with `-eq`, etc.

`declare -i` flips a variable into **integer mode** — every subsequent assignment is parsed as an arithmetic expression:

```bash
declare -i n=5
n="3 + 2"   # n is 5
n+=10       # n is 15  (arithmetic add)
n="x"       # n is 0   (unset name -> 0 in arithmetic)
```

Compare to plain (string) variables:

```bash
m=5
m+=10       # m is "510" — string concatenation
echo $((m + 0))   # arithmetic context — 510 + 0 = 510 (number now)
```

When to use `-i`:

- A counter or accumulator where every assignment is arithmetic.
- Config values that should reject non-numeric input loudly (well, silently to 0 — which is its own footgun).

When **not** to use it:

- Anywhere the value might be a string. The integer attribute is sticky and silently turns `n="hello"` into `n=0`.

In practice, most Bash scripts use the explicit form `n=$((n + 10))` and skip `declare -i` entirely. It's clearer to readers and doesn't lurk as an attribute on the variable.
