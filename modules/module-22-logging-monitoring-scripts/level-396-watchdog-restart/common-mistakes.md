# Common Mistakes

- **Parsing the printed word.** Wrong: `[[ $(systemctl is-active x) == active ]]` fails silently under translations or error text, and the failing command aborts under `set -e`. Right: `if systemctl is-active x > /dev/null; then`.
- **Forgetting the verification.** Wrong: `systemctl restart x; echo "restarted x"`. A restart can return and the service still be down. Check `is-active` again.
- **Retrying in a loop.** Wrong: `until systemctl is-active x; do systemctl restart x; done` hammers a service that cannot start, forever. Restart once, report, move on.
- **Letting one failure stop the others.** Wrong: `exit 1` inside the loop on the first FAILED. Right: set `failed=1` and keep going; exit after the loop.
- **Unprotected restart under `set -e`.** Wrong: a bare `systemctl restart "$svc"` line; if it fails the whole watchdog exits at once. Right: put it in an `if` condition so you decide what a failure means.
