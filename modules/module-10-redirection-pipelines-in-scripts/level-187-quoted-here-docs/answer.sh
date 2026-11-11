#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh JOB" >&2
  exit 2
fi
job=$1

# Quoting the delimiter ('EOF') turns expansion off completely: $BACKUP_DIR,
# $(date +%F) and "$stamp" are copied as plain characters.
cat > "cron-$job.sh" <<'EOF'
#!/usr/bin/env bash
LOG_DIR="$BACKUP_DIR/logs"
stamp=$(date +%F)
echo "run at $stamp" >> "$LOG_DIR/run-$stamp.log"
EOF

echo "wrote cron-$job.sh"
