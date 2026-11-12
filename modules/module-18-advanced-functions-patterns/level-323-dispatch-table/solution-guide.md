# Walkthrough: Dispatch Table

## The plan

A front-door script receives a command name and has to run the right code. You
could write `if [[ $1 == status ]] ... elif ...`, but every new command makes
the ladder longer. A dispatch table separates the data (which command runs
which function) from the logic (look it up, run it).

## Step by step

First the functions, one per command. They take their arguments as `$1`:

```bash
cmd_status()  { echo "$1: running"; }
cmd_restart() { echo "restarting $1"; }
cmd_backup()  { echo "backup of $1 queued"; }
cmd_hosts()   { printf '%s\n' anchovy barracuda cuttlefish; }
```

Then the table. `declare -A` makes an associative array, keyed by text:

```bash
declare -A commands=(
  [status]=cmd_status
  [restart]=cmd_restart
  [backup]=cmd_backup
  [hosts]=cmd_hosts
)
```

The dispatcher takes the first argument off the list with `shift`, so what is
left in `"$@"` belongs to the command:

```bash
(( $# )) || { echo "usage: lf COMMAND [HOST]" >&2; exit 2; }
name=$1
shift
fn=${commands[$name]:-}
```

The `:-` matters: with `set -u`, reading a missing key would kill the script
before you could print a friendly message. An empty `fn` means "unknown":

```bash
if [[ -z $fn ]]; then
  echo "lf: unknown command '$name'" >&2
  exit 2
fi
"$fn" "$@"
```

## The complete solution

See `answer.sh` after you have tried it yourself; it is exactly the pieces above
in this order.

## Try it by hand

```
./solution.sh status marlin
./solution.sh hosts
./solution.sh frobnicate; echo "exit=$?"
```

## Alternative

A `case "$name" in status) cmd_status "$@" ;; ...` works and is perfectly
readable for a handful of commands. The table wins when commands multiply: it
can be listed (`"${!commands[@]}"` gives a free `help` command), checked, or
filled in by other files, which the next levels will use.
