# Common Mistakes

- **Treating `000` as a number.** `[[ $code -ge 400 ]]` is false for 000, so unreachable sites are reported UP.
  - Right: handle `000` first, as its own case.
- **Missing `|| true` after curl.** A timeout makes curl exit non-zero and `set -e` stops the report halfway.
  - Right: `code=$(curl ...) || true`
- **Running `nc` bare.** A closed port is a non-zero exit; outside an `if` it ends the script before the summary.
- **Forgetting `-r` or splitting wrongly.** `read` without `-r` eats backslashes, and reading only two variables glues the rest of the line (host and port) into the second.
  - Right: `read -r kind name a b`
- **Skipping bad lines silently.** A typo like `htp` would vanish from the report and nobody would notice the missing service. Report it as DOWN with a reason.
