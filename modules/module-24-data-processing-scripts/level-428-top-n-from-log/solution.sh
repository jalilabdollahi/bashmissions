#!/usr/bin/env bash
set -euo pipefail
sort -nr fixtures/counts.txt | head -2
