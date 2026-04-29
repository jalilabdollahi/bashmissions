# Export a Variable

Every Unix process has an **environment**: a list of `KEY=VALUE` strings that's copied to its children when they start. A Bash variable is in the environment only if it has been **exported**.

```bash
export GREETING="hello"
bash -c 'echo "$GREETING"'   # hello
```

The same pattern, without `export`:

```bash
GREETING="hello"
bash -c 'echo "$GREETING"'   # (empty)
```

The child `bash` is a separate process. It receives a copy of the parent's environment, but only of *exported* variables.

Equivalent forms:

```bash
export NAME=value           # declare and export in one line
NAME=value; export NAME     # two lines, same effect
declare -x NAME=value       # alternative spelling
NAME=value command          # one-shot: NAME exists only for `command`
```

That last form is great for tests and quick scripts: `LOG_LEVEL=debug ./run.sh` makes `LOG_LEVEL` visible to `run.sh` only, without polluting your interactive shell.

Important behaviours:

- Exporting affects *future* child processes; it does not retroactively touch already-running children.
- Exported variables disappear when the shell exits. To persist them, set them in `~/.bashrc`, `~/.profile`, or a service unit.
- Subshells started with `( ... )` share the parent's full state, including non-exported variables. The export distinction matters only when a *new process* is spawned.

The single-quoted `'...'` argument to `bash -c` is the trick: it preserves the literal `$GREETING` so the **child** shell expands it, not the parent.
