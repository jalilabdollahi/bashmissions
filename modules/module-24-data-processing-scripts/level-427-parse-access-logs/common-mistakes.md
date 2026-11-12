# Common Mistakes

- **Splitting on whitespace.** With `awk '{ print $6 }'`, the request is `"GET`, the agent is split into a dozen words, and every field after the request shifts when the user field is not `-`. Cut on the quotes instead.
- **Trusting positions without checking the shape.** A `"-"` request has one word, so `r[2]` is empty and the path column silently disappears. Test `split()`'s return value.
- **Counting lines with a counter.** `n++` skips blank lines and drifts, so `bad line 4` points at the wrong place. Use `NR`.
- **Printing diagnostics to stdout.** Mixing `bad line 2` into the data stream breaks every tool downstream. Write them to `/dev/stderr`.
- **Leaving the bracket on the date.** `h[4]` is `[04/Mar/2026:10:15:02`. Cut it with `substr(h[4], 2)`.
