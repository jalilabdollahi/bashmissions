# Walkthrough: The Data Pipeline

## The plan
An ETL job is a conveyor belt with quality control at every station. The stages are the same
whether the data is orders, logs or sensor readings: *ingest* (get clean bytes), *validate* (decide what
is allowed through), *transform* (put it in the shape the destination wants), *load* (write it), *report*
(say what happened). Two properties separate a toy from a production job: bad rows are
**set aside with a reason** (never silently dropped), and running the job twice must not
change the result (**idempotence**).

## Step by step
1. **Setup.** Argument checks, the "inbox is empty" shortcut, `work=$(mktemp -d)` with a trap. The
   scratch directory also holds two in-run memories: `ids` (a copy of `db/orders.psv`) and `processed`
   (a copy of `state/processed.list`). Updating the *copies* as each file completes is what lets
   `--dry-run` behave like a real run, including catching duplicates between two files of the same
   dry run.

2. **Ingest.** `tr -d '\r'` makes Windows files look like Unix ones. The header must match exactly;
   otherwise the whole file is quarantined, because if the columns moved, every row in it is
   suspect. The `cksum` of the *original* file is looked up in the processed list: a re-sent file has
   the same CRC and size even if it arrives under a new name.

3. **One awk program for rows.** The known ids are read in `BEGIN` with `getline`. Each rule is
   `reject("reason"); next`, in the order the objective states, so a row with both an empty customer
   and a bad quantity has one well-defined reason. Rejects are written as `LINENO|REASON|row`, which
   is both human-readable and re-processable. Duplicates are counted but are not errors: the row is
   fine, it is just already in.

4. **Transform.** Trim, upper-case the SKU with `toupper`, compute `qty * price` and print with `%.2f`.
   Money is computed once, at transform time, so every later report agrees.

5. **Load.** Append the file's rows to the database *in one `cat`*, record the file's checksum, then move
   the file to `archive/`. The order is deliberate: if the job dies between loading and archiving, the
   next run sees the checksum and skips the file instead of loading it twice.

6. **Report.** Aggregated counts, revenue summed in awk, and the reason table: count then name, sorted
   with `-k1,1nr -k2,2`. Exit status 1 means "look at the rejects".

## Try it by hand
```
./solution.sh --dry-run inbox
./solution.sh inbox && ls rejects archive quarantine
```

## Alternative
Loading each row with a separate append is simpler to write and leaves a half-loaded file if the
script dies in the middle. Building the file's rows first and appending them in one command shrinks
that window to almost nothing, which is as far as plain files can take you; a real database would use
a transaction.
