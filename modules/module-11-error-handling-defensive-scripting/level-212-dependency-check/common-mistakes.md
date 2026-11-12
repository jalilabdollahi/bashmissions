# Common Mistakes

- **Exiting inside the loop.** Wrong: `exit 1` at the first missing tool reports one problem per run. Right: `missing+=("$tool")`, and decide after the loop.
- **Using `which`.** Wrong: `which tidepool` prints its own error text, and its exit status is unreliable across systems. Right: `command -v tidepool > /dev/null 2>&1`.
- **Letting `command -v` print.** Without the redirect the paths of the tools that *are* installed leak into your output. Right: send stdout and stderr to `/dev/null`.
- **Unquoted array expansion in the loop.** Wrong: `for tool in $@` splits strange names. Right: `for tool in "$@"`.
- **Bare `command -v` under `set -e`.** A missing tool aborts the script right there, before the summary. Right: put it in an `if`: `if ! command -v "$tool" ...; then`.
