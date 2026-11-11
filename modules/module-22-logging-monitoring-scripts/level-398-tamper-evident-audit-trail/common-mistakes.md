# Common Mistakes

- **Checksumming with a newline.** Wrong: `echo "$prev|$seq|$msg" | cksum` includes a trailing newline and gives a different number than the spec. Right: `printf '%s' "$prev|$seq|$msg" | cksum`.
- **Using the whole `cksum` output.** Wrong: comparing `3387189980 41` (CRC and size) with the stored `3387189980`. Right: read both fields and keep the first, `read -r sum size`.
- **Chaining from the recomputed value instead of the stored one.** Wrong: setting `prev` to your fresh calculation lets a forged line pass, then you carry on as if nothing happened. Right: `prev=$sum` (the stored value), after checking it matches.
- **Forgetting the sequence number.** Wrong: only verifying checksums misses a deleted *last* line, and reorderings that keep each pair consistent. Compare `seq` with the line counter too.
- **Appending to a damaged log.** Wrong: computing the next entry from the last line without verifying. The new entry would look valid and hide the break. Walk the whole chain first.
