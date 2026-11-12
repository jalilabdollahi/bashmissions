# Common Mistakes

- **Leaving the carriage returns in.** Wrong: the last field of a Windows row ends in `\r`, so every date "fails" validation. Right: `tr -d '\r'` before parsing.
- **Checksumming the cleaned copy.** Wrong: `cksum < "$work/in.csv"` differs from what was recorded earlier if the clean-up logic changes. Right: record and compare the checksum of the file as delivered.
- **Deduplicating only against the database.** Wrong: two rows with the same id in one file, or in two files of one run, both load. Right: also add every accepted id to the in-memory `known` set.
- **Dropping bad rows.** Wrong: `next` without recording anything: the revenue is wrong and nobody knows why. Right: write `LINENO|REASON|row` to a `.rej` file.
- **Archiving before loading.** Wrong: moving the file first: a crash afterwards loses the data silently. Right: load, record the checksum, then archive.
- **Testing the rules in the wrong order.** Wrong: checking the quantity before the field count, so a short row is reported as "bad quantity". Right: follow the documented order so each reason is predictable.
