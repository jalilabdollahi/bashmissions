#!/usr/bin/env bash
# Weekly traffic summary for one site (argument 1).
# The pipeline below is fine, but its status lies: if fetchlog dies half-way,
# sort still exits 0 and we report success on half the data.
# Fix it by changing how the pipeline computes its status, not the pipeline.

if fetchlog "$1" | sort -u > summary.txt; then
  echo "summary ready: $(( $(wc -l < summary.txt) )) distinct lines"
else
  echo "fetch failed for $1" >&2
  exit 3
fi
