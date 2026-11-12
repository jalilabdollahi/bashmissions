#!/usr/bin/env bash
set -euo pipefail

app=${1:-}
if [[ -z $app ]]; then
  echo "usage: solution.sh APP" >&2
  exit 2
fi

# The standard: use XDG_CONFIG_HOME only when it is a non-empty absolute path.
base=${XDG_CONFIG_HOME:-}
if [[ $base != /* ]]; then
  base=$HOME/.config
fi

candidates=("$base/$app/config.ini" "$HOME/.${app}rc")

for path in "${candidates[@]}"; do
  if [[ -f $path ]]; then
    # Show ~ instead of the home directory. A glob test finds the prefix,
    # and "${path#"$HOME"}" cuts it off (the inner quotes make $HOME literal).
    if [[ $path == "$HOME"/* ]]; then
      path="~${path#"$HOME"}"
    fi
    echo "config: $path"
    exit 0
  fi
done

echo "no config found for $app" >&2
exit 1
