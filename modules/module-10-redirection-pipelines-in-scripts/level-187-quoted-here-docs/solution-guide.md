# Walkthrough: Quoted Here-Docs

## The plan

The wrapper's lines are data, not instructions. Our script should copy them
verbatim into a file named after the job.

## Step by step

With the unquoted form from the last level, the shell would replace
`$BACKUP_DIR` with whatever our own environment holds, run `date +%F` while
writing, and drop the quotes' meaning. That is the bug Theo hit: the wrapper
contained our values, not its own.

Quote the delimiter and the shell stops touching the body:

```bash
cat <<'EOF'
LOG_DIR="$BACKUP_DIR/logs"
EOF
```

Prints the line exactly as typed. Now send it to a file. A command can carry
several redirections; the `>` goes before the here-document or after, order is
free here:

```bash
cat > "cron-$job.sh" <<'EOF'
...
EOF
```

Notice that the file NAME is still expanded: the quoting only applies to the
body. Finish with the confirmation line.

## The complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh JOB" >&2
  exit 2
fi
job=$1
cat > "cron-$job.sh" <<'EOF'
#!/usr/bin/env bash
LOG_DIR="$BACKUP_DIR/logs"
stamp=$(date +%F)
echo "run at $stamp" >> "$LOG_DIR/run-$stamp.log"
EOF
echo "wrote cron-$job.sh"
```

## Trying it by hand

```bash
BACKUP_DIR=/nope ./solution.sh backup
cat cron-backup.sh     # still shows $BACKUP_DIR
```

## An alternative

You could escape every `$` with a backslash in an unquoted here-document.
That works for one line and breaks on the fifth. Quoting the delimiter is one
character and covers all of them.
