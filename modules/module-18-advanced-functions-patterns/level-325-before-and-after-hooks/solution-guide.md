# Walkthrough: Before and After Hooks

## The plan

The deploy function should only know *when* to call extras, never *which*
extras exist. So the extras live in two arrays of function names. Registration
is appending a name; deployment is looping over the arrays.

## Step by step

The hooks are ordinary functions that take the site name:

```bash
hook_lock()     { echo "locking $1"; }
hook_snapshot() { echo "snapshotting $1"; }
hook_notify()   { echo "telling #ops about $1"; }
hook_cache()    { echo "warming cache for $1"; }
```

Two empty arrays, one per phase:

```bash
before_hooks=()
after_hooks=()
```

A SPEC like `before:lock` is cut at the colon with `${spec%%:*}` (everything
before the first colon) and `${spec#*:}` (everything after it). After
validating, append with `+=`:

```bash
case $phase in
  before) before_hooks+=("hook_$name") ;;
  after)  after_hooks+=("hook_$name") ;;
esac
```

The deploy function never learns what the hooks do:

```bash
deploy() {
  local h
  for h in "${before_hooks[@]}"; do "$h" "$1"; done
  echo "deploying $1"
  for h in "${after_hooks[@]}"; do "$h" "$1"; done
}
```

Register everything before you deploy. Because validation happens during
registration, a bad SPEC exits with status 2 while nothing has been printed.

## The complete solution

`answer.sh` wraps the validation in a small `register` function so the main
part reads: register each SPEC, then deploy.

## Try it by hand

```
./solution.sh marlin before:lock after:notify
./solution.sh marlin after:cache before:snapshot
./solution.sh marlin before:email; echo "exit=$?"
```

## Alternative

Without arrays you could set flags (`do_lock=1`) and test each one in the
deploy function. It works for two hooks and turns into the `if` pile you were
asked to remove at four.
