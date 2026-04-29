#!/usr/bin/env bash
set -euo pipefail

paste -d: fixtures/names.txt fixtures/scores.txt
