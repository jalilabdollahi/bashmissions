#!/usr/bin/env bash
set -euo pipefail

awk '{print $2}' fixtures/data.txt
