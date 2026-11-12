# Walkthrough: The Plugin System

## The plan
A plugin system answers four questions, and each one has a standard Bash answer. *What plugins are
there?* Read their headers, never run them. *In what order?* Dependencies first, priority as tie-break (a
topological sort). *Can this one run at all?* Decide a status for each plugin from the statuses of the ones it
needs. *What if one misbehaves?* Run each in its own subshell, so the host and the others only ever see an
exit status and some output.

## Step by step
1. **Discovery.** For each `DIR/*.plugin` read only the first 15 lines and pull `name`, `requires` and
   `priority` with `sed -n -E`. A header without a valid name, or a name that an earlier file already uses, is
   recorded as a bad header and takes no further part. `disabled.list` and `--disable` fill one associative
   array.

2. **Ordering (Kahn's algorithm).** Keep a list of `remaining` plugins. In each round, scan it for plugins
   whose requirements are all placed already. Requirements on plugins that do not exist are ignored here: they
   are a *status* problem, not an ordering problem. Among the ready plugins choose the lowest `(priority, name)`,
   append it to `placed`, remove it from `remaining`. If a round finds nothing ready, everything left is stuck
   behind a cycle: those are the `cyclic dependency` plugins and they get no position.

3. **Status, in order.** Because plugins are visited after their requirements, each one can read its
   requirements' final statuses: `disabled` first, then for each requirement `missing dependency`,
   `dependency disabled`, `dependency not usable` (the requirement has any other status than ok), else `ok`.
   Failure therefore propagates down a chain without any extra code.

4. **`list`.** A table in placement order, then cyclic plugins, then bad headers. The exit status says whether
   everything was ok, which is handy for a CI check on the plugin directory.

5. **`run`.** Each usable plugin runs in `( source file; call NAME__HOOK ) > out 2>&1`. The subshell
   inherits the host's functions, so `host_log` works without any export, and anything a plugin does to
   variables, working directory or even `exit` dies with the subshell. Exit status 78 means "the plugin has no such
   hook", a status that no ordinary function returns. Failures are remembered so that plugins which require a
   failed one are skipped with an explanation instead of running on broken ground.

6. **Summary.** Counts for ran, failed, skipped and no hook, and exit status 1 if anything failed.

## Try it by hand
```
./solution.sh list
./solution.sh --disable tides run pre_deploy
```

## Alternative
Sourcing all plugins into the host shell is simpler and makes cooperation trivial (shared variables). It also
means any plugin can overwrite a host function, call `exit`, or leave the shell in a state you cannot predict.
The subshell boundary costs a little convenience and buys a system you can run in production.
