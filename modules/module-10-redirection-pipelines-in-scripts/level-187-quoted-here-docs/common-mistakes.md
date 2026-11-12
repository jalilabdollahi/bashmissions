# Common Mistakes

- **Forgetting the quotes.** Variables turn into your own values, or into nothing.
  - Wrong: `cat > "cron-$job.sh" <<EOF` (the file ends up with `LOG_DIR="/logs"` if BACKUP_DIR is unset)
  - Right: `cat > "cron-$job.sh" <<'EOF'`
- **Quoting the wrong place.** Quoting the file name does nothing for the body.
  - Wrong: `cat "cron-$job.sh" > <<EOF`
  - Right: quote the delimiter word after `<<`
- **Escaping a few dollars and missing one.** The one you missed expands silently.
  - Wrong: `LOG_DIR="\$BACKUP_DIR/logs"` and `stamp=$(date +%F)` unescaped
  - Right: quote the delimiter once
- **Using different words to open and close.** `<<'EOF'` must end with a bare `EOF`, no quotes.
  - Wrong: closing with `'EOF'`
  - Right: closing line is `EOF`
