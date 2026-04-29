# Local vs Global Scope

By default, every Bash variable is **global** — even if assigned inside a function. The `local` keyword changes that: it creates a variable that exists only for the lifetime of the function call.

```bash
x="global"
demo() {
  local x="local"
  echo "inside: $x"
}
demo
echo "outside: $x"
```

Output:

```
inside: local
outside: global
```

Bash uses **dynamic scoping**: a function can see and modify variables from any enclosing function on the call stack, unless those callers used `local`. This is unusual — most languages use lexical scoping — and it's why disciplined use of `local` matters.

Idioms:

- Mark every function parameter as `local`:
  ```bash
  greet() {
    local name="$1"
    echo "hello, $name"
  }
  ```
- Combine attributes: `local -i count=0`, `local -r MAX=10`, `local -a items=()`.
- Avoid the `name=value command` form, which doesn't make `name` local — it just sets it for one command's environment.

`local` only works inside a function. At the top level it errors with `local: can only be used in a function`.
