# Common Mistakes

- **Layers applied in the wrong order.** Wrong: reading the file after the environment lets the file beat the environment. Right: defaults, then file, then `${RELAY_PORT:-$port}`.
- **Using `${VAR-default}` where empty should count as absent.** Wrong: `RELAY_HOST= ./solution.sh` prints `host=` (empty). Right: `${RELAY_HOST:-$host}`, with the colon.
- **Cutting the value at the second `=`.** Wrong: `cut -d= -f2` returns `relay.example/?zone` for `RELAY_HOST=relay.example/?zone=eu`. Right: `IFS='=' read -r key value` keeps `zone=eu` in the value.
- **Failing when the optional file is missing.** Wrong: `done < "$1"` with a missing file aborts under `set -e` with an error. Right: check `[[ -r ${1:-} ]]` first, and treat a missing file as an empty layer.
- **Letting the file's empty value erase the default.** Wrong: `RELAY_PORT=` in the file sets `port=` to nothing. Right: skip empty values with `[[ -n $value ]] || continue`.
