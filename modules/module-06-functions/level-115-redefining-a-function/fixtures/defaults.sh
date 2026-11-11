# defaults.sh - shared Lanternfish site behaviour. Source it; do not edit it.

# notify MESSAGE...  - tell a human something
notify() {
  echo "notice: $*"
}

# retention_days - how many days backups are kept
retention_days() {
  echo 30
}

# report SITE - one status sentence, built from the two helpers above
report() {
  notify "$1 keeps backups for $(retention_days) days"
}
