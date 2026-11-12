# Walkthrough: The Audit Logger

## The plan
A hash chain turns "this log was not edited" into something checkable: every entry's checksum covers its own
fields *and the previous entry's checksum*, so a change anywhere breaks every later link. This level builds a
production-shaped version around that core, and each extra feature closes a specific hole. The **chain** catches
edits and deletions in the middle. The **sequence number** catches missing lines. The **anchor** (a copy of the
latest sequence and checksum stored elsewhere) catches what the chain cannot: a truncated tail, or a tail rewritten
with correctly recomputed checksums. **Rotation** keeps files small without breaking the chain. The **lock** stops two
writers from forking it.

## Step by step
1. **`checksum`.** `cksum` of the exact text `PREV|SEQ|TS|ACTOR|ACTION|DETAIL`, with `printf '%s'` so no newline
   sneaks in. Everything that creates or checks an entry goes through this one function.

2. **`walk`, the core.** For each file (segments first, `current.log` last) read lines with
   `IFS='|' read -r seq sum ts actor action detail`; the last variable swallows any further `|`, so details with
   pipes are intact. State (`prev`, `expect`) lives *outside* the per-file loop, which is what makes the chain continue
   across rotation. Checks run in a fixed order, format, sequence, checksum, and the first failure returns a precise
   place: base file name and line number.

3. **Commands as thin layers.** `verify` prints the walk's verdict. `append` locks, walks, and uses `last_seq` and
   `last_sum` to build the next line; it refuses to extend a broken log, because new valid-looking entries would bury the
   damage. `search` refuses too, unless `--force`.

4. **The anchor.** `checkpoint` writes `SEQ SUM` through a temporary file and `mv`. `verify --anchor` checks three
   things in order: the file exists; the log reaches at least the anchored sequence (else `TRUNCATED`); and the checksum
   the log holds for that sequence number equals the anchored one (else the history was rewritten consistently). An anchor that
   is *older* than the end of the log is fine, that is just a log that has grown since the checkpoint. Keep the
   anchor somewhere the log's writers cannot reach (another machine, an e-mail, a printout) and the guarantee becomes
   real.

5. **Rotation.** Count the entries in `current.log`; when there are at least `--max`, `mv` it to the next free
   `seg-NNNN.log`. Nothing else is needed: the next `append` starts a new `current.log` whose PREV is read from the
   last segment by `walk`.

6. **The lock.** `mkdir audit/lock` is atomic, so it works as a lock; a `trap` removes it however the command ends.
   Readers (`verify`, `search`) do not lock: they are safe because writers only append whole lines.

## Try it by hand
```
AUDIT_NOW=2026-11-12T03:10:00 ./solution.sh append mara DEPLOY shrimp-api 2.4.0
./solution.sh checkpoint
./solution.sh verify --anchor
```

## Alternative
Putting the previous checksum in a separate "index" file is simpler to parse, but it can be rewritten as easily
as the log. Keeping the chain inside the entries, plus a tiny external anchor, means a single trusted number vouches for
the entire history.
