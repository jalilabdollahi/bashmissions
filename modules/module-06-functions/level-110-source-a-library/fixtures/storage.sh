# storage.sh - Lanternfish storage helpers. Meant to be sourced, not run.
STORAGE_LIB_VERSION=3

# kb_to_mb KB  ->  prints whole megabytes, rounded up
kb_to_mb() {
  echo $(( ($1 + 1023) / 1024 ))
}
