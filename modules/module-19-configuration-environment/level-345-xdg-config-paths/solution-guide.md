# Walkthrough: XDG Config Paths

## The plan

Two decisions: which base folder to use, and which candidate file wins. Decide the
base first with a small rule, put the candidates in an ordered list, and let the
first existing file end the search.

## Building it

The XDG Base Directory standard says: if `XDG_CONFIG_HOME` is set and not empty,
use it; if it is relative, ignore it (a relative path would mean "wherever the
program happens to run", which is a bug magnet); otherwise use `~/.config`.
Because `set -u` is on, read it as `${XDG_CONFIG_HOME:-}`, which never fails:

```bash
base=${XDG_CONFIG_HOME:-}
if [[ $base != /* ]]; then base=$HOME/.config; fi
```

One test covers all three bad cases: an unset or empty value does not start with
`/`, and neither does a relative one.

Then list candidates by priority, the XDG file first and the legacy dotfile
second:

```bash
candidates=("$base/$app/config.ini" "$HOME/.${app}rc")
```

Mind that the base is consulted alone: when `XDG_CONFIG_HOME` is set, `~/.config`
is not searched. Walk the list with `[[ -f $path ]]`, which accepts regular files
only, so a directory that happens to be named `config.ini` is skipped.

For display, replace the home prefix: if the path matches `"$HOME"/*`, print
`~${path#"$HOME"}`. The quotes inside the expansion make Bash treat `$HOME`
literally rather than as a pattern.

Finally the failure: message on stderr, `exit 1`.

## Trying it by hand

```
mkdir -p ~/.config/pelican && touch ~/.config/pelican/config.ini
./solution.sh pelican
XDG_CONFIG_HOME=/tmp/elsewhere ./solution.sh pelican
```

## Alternative

You could build the whole answer with nested `${A:-${B:-C}}` expressions, but the
"must be absolute" rule cannot be expressed that way, so the explicit `if` is
clearer and complete.
