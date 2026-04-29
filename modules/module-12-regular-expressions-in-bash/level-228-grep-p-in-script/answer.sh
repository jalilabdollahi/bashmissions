#!/usr/bin/env bash
set -euo pipefail

grep -Po 'id=\K[0-9]+' fixtures/data.txt
