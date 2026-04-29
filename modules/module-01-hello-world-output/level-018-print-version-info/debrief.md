# Print Version Info

A common script pattern: gather a few inputs into named variables, then compose them into output. Naming the values up front pays off once a script grows past a handful of lines.

```bash
name="$1"
version="$2"
echo "$name version $version"
```

Three small things to internalize:

- **No spaces around `=`** in assignments. `name = "$1"` is interpreted as a command call.
- **Quote the right-hand side**: `name="$1"` survives spaces; `name=$1` does not when the argument has spaces.
- **Inside double quotes, `$var` expands**. `"$name version $version"` becomes one composed string. Single quotes would print the dollar signs literally.

A rougher form people write first:

```bash
echo "$1 version $2"
```

That works for the test, but as the script grows you want descriptive names — debugging `$7` six months later is no fun. Use named variables as soon as a value has a meaning beyond "the third argument."

`printf` is interchangeable here: `printf '%s version %s\n' "$name" "$version"`. Most style guides prefer `printf` for anything with a fixed format.
