# Common Mistakes

- **Batching instead of pooling.** Starting MAX jobs then calling a bare `wait` leaves seats empty while the slowest job finishes.
  - Right: refill one seat at a time with `wait -n`.
- **Forgetting the straggler loop.** After the last `resize` is started, up to MAX jobs are still running; the script exits early or the final counts are too low.
  - Right: `while (( running > 0 )); do reap_one; done` after the main loop.
- **Letting `wait -n` kill the script.** A failed job makes it return non-zero.
  - Wrong: `wait -n` alone with `set -e` on.
  - Right: `if wait -n; then ...; else ...; fi`
- **A counter that is never decremented.** The pool fills up once and then waits forever.
  - Right: `running=$((running - 1))` every time you reap.
- **Using `>` where you need `>=`.** `while (( running > max ))` allows MAX+1 jobs.
  - Right: `while (( running >= max ))` before starting a new one.
