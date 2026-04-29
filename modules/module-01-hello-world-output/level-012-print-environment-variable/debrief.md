# Print Environment Variable

Every Unix process inherits an **environment**: a set of `KEY=value` pairs passed down from its parent. In a Bash script, these are visible as regular variables.

The most common ones:

- `$HOME` — the current user's home directory (e.g. `/home/jalil`).
- `$USER` — the login name.
- `$PATH` — colon-separated list of directories searched for commands.
- `$PWD` — the current working directory.
- `$SHELL` — the user's login shell.

You can list everything with `env` or `printenv`. Set your own with `export NAME=value` (more in module 19).

```bash
echo "HOME=$HOME USER=$USER"
# HOME=/home/jalil USER=jalil
```

Because actual values differ per machine, the test uses a regex (`HOME=\S+ USER=\S+`) — you can run your solution and eyeball it.
