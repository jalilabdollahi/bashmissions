# Walkthrough: Memoize

## The plan

Memoizing means putting a cache in front of a function whose answer depends
only on its argument. The function first checks the cache. On a miss it does
the real work and stores the result; on a hit it skips the work.

## Step by step

Start with the argument check, then the cache, an associative array that
lives for the whole run:

```bash
(( $# )) || { echo "usage: solution.sh DOMAIN..." >&2; exit 2; }
declare -A cache=()
```

The function asks the question "is this key already in the notebook?". The
expansion `${cache[$domain]+x}` yields `x` when the key exists and nothing when
it does not, so `-z` means "miss":

```bash
registrar_of() {
  local domain=$1
  if [[ -z ${cache[$domain]+x} ]]; then
    cache[$domain]=$(whois-lookup "$domain")
  fi
  registrar=${cache[$domain]}
}
```

Why does the function set `registrar` instead of printing the result?
Because of where the work happens. `line=$(registrar_of "$d")` would run the
function in a subshell, and `cache[$domain]=...` would be stored in a copy of
the shell that disappears right after. The next call would find the cache
empty and call `whois-lookup` again. Setting a variable and calling the
function directly keeps the cache in the main shell.

The loop is then trivial:

```bash
for domain in "$@"; do
  registrar_of "$domain"
  echo "$domain -> $registrar"
done
```

## Try it by hand

```
./solution.sh harbourbakery.example gullanchor.example harbourbakery.example
cat .calls.log
```

The stub records each real call in `.calls.log`; every domain should appear
there once.

## Alternative

Using `[[ -v cache[$domain] ]]` for the existence test is equivalent in Bash
5. A plain `[[ -n ${cache[$domain]:-} ]]` is tempting but treats an empty
answer as a miss and would ask again.
