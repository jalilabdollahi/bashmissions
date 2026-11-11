# Walkthrough: Function Factories

## The plan

Three near-identical functions differ in one word. A factory is a function
that receives that word and defines the function for you. In Bash the tool for
turning text into a definition is `eval`, which is powerful and dangerous in
exactly the same measure, so the plan has two parts: validate, then generate.

## Step by step

Validate first. The level becomes part of a function name *and* part of text
that Bash will execute, so allow only what you expect:

```bash
make_logger() {
  local level=$1
  if [[ ! $level =~ ^[a-z]+$ ]]; then
    echo "make_logger: bad level name '$level'" >&2
    exit 2
  fi
```

Now the generation. The whole definition is one double-quoted string, and you
decide which `$` signs are filled in now and which later:

```bash
  eval "log_$level() { printf '[%s] %s\\n' '${level^^}' \"\$*\"; }"
}
```

- `log_$level` and `${level^^}` are expanded while the string is built, so
  for `warn` the text becomes `log_warn() { printf ... 'WARN' "$*"; }`.
- `\$*` keeps its dollar sign, so the generated function expands its own
  arguments when it is called.
- `\\n` becomes `\n` inside the printf format.

To see what eval receives, replace `eval` with `echo` while testing.

Then create all loggers, and call them (the names were validated, so
`"log_$level"` is safe):

```bash
for level in "$@"; do make_logger "$level"; done
for level in "$@"; do "log_$level" "$message"; done
```

## Try it by hand

```
./solution.sh "disk almost full" warn error
./solution.sh hi 'x;touch pwned'; ls pwned
```

The second command must be refused, and `pwned` must not exist.

## Alternative

Without `eval` you can write one function `log LEVEL words...` and call it as
`log warn "..."`. That is simpler and safer, and the right choice when you
can live with the different call shape. Factories earn their place when other
code expects distinct function names, as with hooks and plugins.
