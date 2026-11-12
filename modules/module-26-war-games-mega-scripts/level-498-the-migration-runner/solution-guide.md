# Walkthrough: The Migration Runner

## The plan
A database schema changes over time, and every server must go through the same changes in the same order, exactly once. The standard answer is the *migration*: a numbered file describing one change, plus a *ledger* that remembers which migrations a given database has already seen. The runner compares folder and ledger and does the minimum that is safe.

The most important idea is **idempotence**: running `up` twice must do the same as running it once. That follows directly from the ledger: a migration in the ledger is never run again. The second most important is **history is immutable**: once a migration is applied, its file must not change, or different servers will have run "the same" migration with different content. The ledger stores a fingerprint (`cksum`) of each applied file so any edit is detected.

## Step by step

1. **Scan the folder.** A regex on the file name extracts the id, name and kind (`up` or `down`). Anything that does not match (a README) is ignored. Two `.up` files with one id are ambiguous: stop with an error. For each `.up` file compute `cksum < file`.

2. **Read the ledger** into arrays keyed by id. A missing ledger just means nothing applied yet.

3. **Compute a state per id.** In the ledger and on disk with the same sum: `applied`. Same id, different sum: `MODIFIED`. In the ledger but no file: `MISSING`. Only on disk: `pending`. `status` and `verify` are views of this one function.

4. **Refuse unsafe histories (`up`).** Before any change, check that no applied migration was edited or deleted, and that no pending migration is *older* than the newest applied one. The out-of-order case is subtle: migration 002 was never run on a database that already has 003, and running it now applies changes in an order no other server has seen. The flag `--allow-out-of-order` is an explicit "I know" override. Because these checks come first, a refusal leaves the database untouched.

5. **Apply in order, record at once.** For each pending id (up to `TARGET`), run `dbexec`. On success append to the ledger *immediately* and say so. On failure stop right there: earlier successes stay recorded, so the next `up` resumes at the failed migration, and nothing later ever runs on top of a broken state. Recording before success would claim a change that did not happen; recording all at the end would forget the successes if the script died halfway.

6. **Roll back (`down`).** Revert newest first, each needs its `.down` file. The ledger line is removed with a temp file and `mv`, so the ledger is never half-written. A missing down file stops the rollback instead of skipping a step, because skipping would break the order.

## Complete solution
The heart of `up`:
```bash
for id in "${pending[@]}"; do
  rc=0; dbexec "$dir/$id-${file_name[$id]}.up" || rc=$?
  (( rc == 0 )) || { echo "FAILED $id ${file_name[$id]} (exit $rc)" >&2; exit 1; }
  echo "$id ${file_sum[$id]} ${file_name[$id]}" >> "$ledger"
  echo "applied $id ${file_name[$id]}"
done
```

## Try it by hand
```bash
mkdir migrations
echo 'CREATE TABLE users;' > migrations/001-create-users.up
echo 'DROP TABLE users;'   > migrations/001-create-users.down
./solution.sh migrations schema.ledger status
./solution.sh migrations schema.ledger up
./solution.sh migrations schema.ledger up      # nothing to do
./solution.sh migrations schema.ledger down
```
(`dbexec` is a stub that only records its calls.)

## Alternative
Tools like Flyway, Liquibase and Rails migrations work the same way, often with the ledger inside the database. Keeping it in the same transaction as the change is the production refinement; a file ledger needs the "record after success" discipline instead.
