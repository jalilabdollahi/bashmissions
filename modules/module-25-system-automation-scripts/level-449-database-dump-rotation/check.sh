#!/usr/bin/env bash
# If a dump for the test's STAMP was written, it must decompress to exactly the
# database's SQL (not just be a valid gzip file).
db=${1:-} stamp=${3:-}
f=backups/$db-$stamp.sql.gz
[[ -f $f ]] || exit 0
if ! gunzip -c "$f" | cmp -s - "fixtures/db/$db.sql"; then
  echo "$f does not decompress to the output of pg_dump $db"
  exit 1
fi
