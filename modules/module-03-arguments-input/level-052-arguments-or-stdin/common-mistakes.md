# Common Mistakes

- **Using `$1` bare under `set -u`.** `host=$1` aborts with `unbound variable`
  when nothing is passed, so the stdin fallback never happens. Right:
  `host=${1:-}`.
- **Reading stdin first.** `read -r host` before looking at the argument makes
  the script wait for typing even when `anchovy` was given. Read only inside the
  fallback guard.
- **Validating only one route.** Checking the argument for emptiness but not what
  `read` returned lets a blank line through. Validate after both routes.
- **Forgetting `|| true`.** With no input, `read` fails and `set -e` exits with
  status 1 instead of your usage message and status 2.
