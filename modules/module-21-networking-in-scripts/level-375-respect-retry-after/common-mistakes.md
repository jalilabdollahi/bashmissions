# Common Mistakes

- **Not stripping the `\r`.** The header value is `3\r`, so `sleep` complains or the number test fails.
  - Right: `... | tr -d '\r' | ...`
- **Matching only `Retry-After`.** A server that sends `retry-after` is just as correct.
  - Wrong: `grep '^Retry-After:'`
  - Right: `grep -i '^retry-after:'`
- **An unbounded retry loop.** `while true` plus a server that never recovers means a script that never ends.
  - Right: `for (( attempt = 1; attempt <= 4; attempt++ ))`
- **Retrying every error.** Only 429 (and often 503) are worth another go; a 404 or 401 will fail identically.
- **Letting `pipefail` abort on a missing header.** `grep` exits 1 when nothing matches, which kills the script under `set -euo pipefail`.
  - Right: `... || true`, then validate the value and fall back to a default.
