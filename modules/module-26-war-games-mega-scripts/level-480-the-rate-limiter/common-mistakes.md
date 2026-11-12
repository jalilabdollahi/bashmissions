# Common Mistakes

- **Setting `last=ts` after every refill.** With 9 seconds between requests and a 10 second period, the bucket never refills because the leftover is discarded each time. Advance `last` by `added * spt`.
- **Forgetting the full-bucket reset.** An idle client keeps an old `last`, so when it finally spends a token the next refill calculation credits it for the whole idle time. After capping, set `last=ts`.
- **Letting the bucket exceed capacity.** `tokens=$((tokens + added))` with no cap turns a one-hour pause into thousands of tokens. Clamp to `cap`.
- **Dividing by zero or text.** A cost or timestamp that is not a number makes `$(( ))` explode or silently read it as a variable. Validate with `[[ $x =~ ^[0-9]+$ ]]` before arithmetic.
- **Using `date +%s`.** The whole mission is about replayable time. A real clock makes every test depend on when it runs.
