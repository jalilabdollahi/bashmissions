# Walkthrough: Decorators

## The plan

A decorator is a wrapper with the same name and the same calling convention as
the function it wraps. Callers do not change. The trick in Bash is that you
cannot call "the old version" of a name you just redefined, so first you save the
old body under another name.

## Step by step

`declare -f NAME` prints the function's source as `NAME () { ... }`. If NAME
is not a function it prints nothing and fails, which doubles as the existence
check:

```bash
if ! def=$(declare -f "$fn"); then
  echo "decorate: no such function: $fn" >&2
  return 1
fi
```

The text starts with the name, so putting `orig_` in front and evaluating it
creates an identical copy under a new name:

```bash
eval "orig_$def"
```

(This is safe: `def` is Bash's own printout of a function you wrote, not
user input.)

Next, redefine the original name. To avoid writing a wrapper body per
function, hand everything to one generic function, `traced`, with the name as
its first argument:

```bash
eval "$fn() { traced $fn \"\$@\"; }"
```

`$fn` is filled in now; `\"\$@\"` waits until the wrapper is called.

`traced` does the visible work. Capturing the status needs `|| rc=$?`,
because under `set -e` a failing `orig_...` call would end the whole script
before you could print the `<<` line:

```bash
traced() {
  local fn=$1 rc=0
  shift
  echo ">> $fn $*"
  "orig_$fn" "$@" || rc=$?
  echo "<< $fn rc=$rc"
  return "$rc"
}
```

Finally `decorate "$1"; "$1" "$2"`.

## Try it by hand

```
./solution.sh restart_service web
./solution.sh restart_service broken; echo "exit=$?"
./solution.sh nope x
```

## Alternative

Writing the wrapper by hand (`restart_service() { echo ">> ..."; ...; }`)
is simplest for one function, but it needs the original saved under a name
first, and gets repeated for every function. `decorate` does it for any name.
