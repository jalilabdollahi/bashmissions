# Walkthrough: Tamper-Evident Audit Trail

## The plan
Make each line depend on the one before it. Entry N stores a checksum of its own
text *plus* the checksum of entry N-1. Edit line 5 and its checksum no longer
matches; fix that checksum and line 6's stored value no longer matches line 5's
new one; and so on to the end. A forger would have to rewrite every later line, and
anyone holding an old copy of just the last checksum could spot it.

## Step by step
1. A helper that returns the checksum for `PREV|SEQ|MESSAGE`. `printf '%s'`
   avoids the trailing newline that `echo` would add, and `cksum` prints the CRC
   followed by the byte count, of which you keep only the first number:

   ```bash
   checksum() { local sum size; read -r sum size < <(printf '%s' "$1|$2|$3" | cksum); echo "$sum"; }
   ```

2. A walker over the log. Split each line with `IFS='|' read -r seq sum msg`
   (the last variable takes the rest, so messages may contain `|`), count the
   line, and require two things: `seq` equals the line number, and `sum` equals
   the recomputed value using the *stored* previous sum. Remember `sum` as the
   new `prev`. On the first mismatch record the line number and stop.

3. `verify` prints `OK: N entries` or `TAMPERED: line N`.

4. `append` walks first. A broken log is never extended, because new entries
   would make the damage look official. Then it writes the next entry from the
   last good sum: `next=$((entries + 1))`, checksum, `>>`.

## Try it by hand
```
./solution.sh append audit.log "alice created account bob"
./solution.sh append audit.log "bob granted admin"
./solution.sh verify audit.log
sed -i.bak 's/admin/nothing/' audit.log
./solution.sh verify audit.log
```

## Alternative
A separate file holding only the latest checksum is simpler to read, but it can
be edited just as easily as the log. The chain in the lines themselves means
that a single trusted copy of the last checksum, stored elsewhere, vouches for
the whole file. Real systems use SHA-256 for this; `cksum` is a CRC, which
catches accidents and casual edits but not a determined forger.
