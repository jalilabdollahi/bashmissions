# Print Script Name

In Bash, the positional parameters `$0`, `$1`, `$2`, … hold the words on the command line that started the script. The first one is special:

- `$0` — the script itself, exactly as invoked. Could be `solution.sh`, `./solution.sh`, or an absolute path like `/usr/local/bin/foo`.
- `$1`, `$2`, … — the arguments passed *after* the script name.

Because `$0` may include a directory, scripts that want only the bare filename pipe it through **`basename`**:

```bash
basename /usr/local/bin/foo   # foo
basename ./solution.sh        # solution.sh
basename solution.sh          # solution.sh
```

Combined:

```bash
echo "script: $(basename "$0")"
```

Self-aware scripts use this for things like:
- usage strings: `echo "Usage: $(basename "$0") <args>"`
- log lines that include their own name
- behaving differently when invoked through a symlink (`ln -s mytool foo` lets one script act as both `mytool` and `foo`)
