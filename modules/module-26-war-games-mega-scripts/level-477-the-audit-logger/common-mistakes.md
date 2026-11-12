# Common Mistakes

- **Trusting the chain to detect truncation.** Wrong: `verify` says OK after the last three entries were deleted. Right: compare with an anchor (the last SEQ and SUM stored elsewhere) using `verify --anchor`.
- **Restarting state per file.** Wrong: resetting `prev=0` and `expect=1` at the start of every segment, so a rotated log looks broken. Right: keep both outside the per-file loop.
- **Losing pipes in the detail.** Wrong: `IFS='|' read -r seq sum ts actor action` leaves the rest in `action`, or `cut -d'|' -f6` cuts the detail short. Right: let the final variable of `read` take the remainder.
- **Appending to a damaged log.** Wrong: computing the next entry from the last line without checking the chain; the new entry hides the break. Right: walk first and refuse.
- **Locking readers.** Wrong: taking the lock in `verify` and `search`, so an audit blocks while a deploy logs. Right: lock only commands that write.
- **A non-atomic anchor.** Wrong: `echo ... > audit/anchor` interrupted mid-write leaves an empty anchor. Right: write `anchor.new` and `mv` it into place.
